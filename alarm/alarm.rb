#!/usr/bin/env ruby
require 'packetfu'
require 'base64'
require 'apachelogregex'

def main()
    # Get right number of arguments from command line
    if ARGV.length != 0 && ARGV.length != 2
        puts "ERROR: Script invoked incorrectly"
        puts "USAGE: Alarm -- ruby alarm.rb"
        puts "USAGE: Analyze Log  -- ruby alarm.rb -r <logfile>"
        exit 1
    end

    if ARGV.length == 0
        liveCapture()
    else  # That is, argv.length == 2
        if ARGV[0] != '-r'
            print "Unrecognized Option ", ARGV[0], "\n"
            exit 1
        else  # Go ahead and analyze file
            analyzeLog(ARGV[1])
        end
    end
    exit 0
end

def analyzeLog(inputFile)
    parser = ApacheLogRegex.new('%h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-agent}i\"')
    File.open(inputFile, "r") do |f|
        f.each_line do |line|
            dictio = parser.parse(line)
            if isNmapScan(dictio["%r"]) || isNmapScan(dictio["%{User-agent}i"])
                puts line
            elsif isNiktoScan(dictio["%r"]) || isNiktoScan(dictio["%{User-agent}i"])
                puts line
            elsif isCreditCard(dictio["%r"]) || isCreditCard(dictio["%{User-agent}i"])
                puts line
            elsif isBadPHP(dictio["%r"]) || isBadPHP(dictio["%{User-agent}i"])
                puts line
            elsif isShellShock(dictio["%r"]) || isShellShock(dictio["%{User-agent}i"])
                puts line
            end
        end
    end
end

def liveCapture()
    stream = PacketFu::Capture.new(:start => true, 
                :iface => 'eth0', :promisc => false)

    me = PacketFu::Utils.whoami?()[:ip_saddr]
    counter = 0
    stream.stream.each do |raw|
        pkt = PacketFu::Packet.parse raw
            
        # Reset these each times so no "dead squirrls"
        scanType = nil
        if pkt.is_tcp?
            # If I sent the packet, don't report it
            if pkt.ip_saddr == me
                next
            end

            # Check for known scans
            if isNullScan(pkt.tcp_flags)
                scanType = "NULL"
            elsif isFinScan(pkt.tcp_flags)
                scanType = "FIN"
            elsif isXmasScan(pkt.tcp_flags)
                scanType = "Xmas"
            elsif isNmapScan(pkt.payload)
                scanType = "Nmap"
            elsif isNiktoScan(pkt.payload)
                scanType = "Nikto"
            elsif isSynScan(pkt.tcp_flags)
                scanType = "SYN"
            end

            # Only print out inident report if recognized intrusion
            if (scanType != nil)
                counter += 1  
                print counter,". ","ALERT ", scanType
                print " scan is detected from ", pkt.ip_saddr
                print " (", pkt.proto.last, ") "
                print "\n"
            end
            if (isCreditCard(pkt.payload))
                counter += 1
                cc = getCreditCard(pkt.payload)
                print counter,". ", "ALERT credit card ", cc
                print " leaked in the clear from "
                print pkt.ip_saddr
                print " (", pkt.proto.last, ") "
                print "\n"
            end
        end
    end
end

# If the sum of all flags is 0, then it is a null scan, otherwise it is 
# something else
def isNullScan(fls)
    sumFlags = fls.ack + fls.psh + fls.urg + fls.rst + fls.fin + fls.syn
    if (sumFlags == 0)
        return true
    else
        return false
    end
end


def isFinScan(fls)
    # If fin bit not set, just get out
    if (fls.fin == 0)
        return false
    end

    sumOthers = fls.ack + fls.psh + fls.urg + fls.rst + fls.syn

    # At this point, we know that fin bit was set, if others not
    # then it is a fin scan 
    if (sumOthers == 0)
        return true
    else
        return false
    end
end

def isXmasScan(fls)
    sumOthers = fls.ack + fls.syn + fls.rst

    # If anything else lit up, return false
    if (sumOthers != 0)
        return false
    end

    if (fls.fin == 1 && fls.psh == 1 && fls.urg == 1)
        return true
    else
        return false
    end
end

def isSynScan(fls)
    sumOthers = fls.ack + fls.rst + fls.fin + fls.psh + fls.urg
    if (sumOthers != 0)
        return false
    end

    if (fls.syn == 1)
        return true
    else
        return false
    end
end

# Looks for 2 different credit card formats in the payload
# Returns the number if found, otherwise, returns nil
def getCreditCard(payload)
    # VISA
    matchList = payload.scan(/(4\d{3}(\s|-)?\d{4}(\s|-)?\d{4}(\s|-)?\d{4})\D/) 
    if matchList.length > 0
        return matchList[0][0]
    end

    # MASTER CARD
    #form with dashes
    matchList = payload.scan(/(5\d{3}(\s|-)?\d{4}(\s|-)?\d{4}(\s|-)?\d{4})\D/) 
    if matchList.length > 0
        return matchList[0][0]
    end

    # DISCOVER
    #form with dashes
    matchList = payload.scan(/(6011(\s|-)?\d{4}(\s|-)?\d{4}(\s|-)?\d{4})\D/) 
    if matchList.length > 0
        return matchList[0][0]
    end

    # AMERICAN EXPRESS
    #form with dashes
    matchList = payload.scan(/(3\d{3}(\s|-)?\d{4}(\s|-)?\d{4}(\s|-)?\d{4})\D/) 
    if matchList.length > 0
        return matchList[0][0]
    end

    return nil

end

# Takes in a payload and returns true if there is a credit card number,
# false otherwise
def isCreditCard(payload)
    cardNo = getCreditCard(payload)
    if cardNo.nil?  # indicates no card found
        return false
    else
        return true
    end
end


# Accepts a payload from a tcp packet and searches for nmap in binary and
# plain text ignoring case
def isNmapScan(payload)
    if payload.scan(/Nmap/i).length > 0
        return true
    elsif payload.scan(/\x4E\x6D\x61\x70/).length > 0
        return true
    else
        return false
    end
end


# Accepts a payload from a tcp packet and searches for nikto in binary and
# plain text ignoring case
def isNiktoScan(payload)
    if payload.scan(/Nikto/i).length > 0
        return true
    elsif payload.scan(/\x4E\x69\x6B\x74\x6F/).length > 0
        return true
    else
        return false
    end
end

# Pulls out phpMyAdmin badness
def isBadPHP(payload)
    if payload.include?("phpMyAdmin")
        return true
    else
        return false
    end
end

def isShellShock(payload)
    if payload.include?("() { :;};")
        return true
    else
        return false
    end
end

main
