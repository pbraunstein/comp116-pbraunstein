require 'packetfu'
require 'base64'

def main()
    stream = PacketFu::Capture.new(:start => true, 
                :iface => 'eth0', :promisc => false)
    counter = 0
    stream.stream.each do |raw|
        pkt = PacketFu::Packet.parse raw
        # Reset these each times so no "dead squirrls"
        scanType = nil
        if pkt.is_tcp?
            if isNullScan(pkt.tcp_flags)
                scanType = "NULL"
            elsif isFinScan(pkt.tcp_flags)
                scanType = "FIN"
            elsif isXmasScan(pkt.tcp_flags)
                scanType = "Xmas"
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
    #form with dashes
    matchList = payload.scan(/\d{4}-\d{4}-\d{4}-\d{4}/) 
    if matchList.length > 0
        return matchList[0]
    end

    # form with spaces 
    matchList = payload.scan(/\d{4}\s+\d{4}\s+\d{4}\s+\d{4}/)
    if matchList.length > 0
        return matchList[0]
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

main
