require 'packetfu'

def main()
    stream = PacketFu::Capture.new(:start => true, 
                :iface => 'eth0', :promisc => false)

    stream.stream.each do |raw|
        pkt = PacketFu::Packet.parse raw
        #if pkt.is_tcp?
        #   print "source:", pkt.ip_saddr,"\
        #       , dest:", pkt.ip_daddr, ",\ 
        #       proto:", pkt.proto.last, "\n"
        #   print "flags:", pkt.tcp_flags, "\n"
        #end
        type = nil
        if pkt.is_tcp?
            pkt.tcp_flags.ack = 0;
            pkt.tcp_flags.rst = 0;
            pkt.tcp_flags.syn = 0;
            pkt.tcp_flags.urg = 0;
            pkt.tcp_flags.psh = 0;
            pkt.tcp_flags.fin = 0;
            puts isSynScan(pkt.tcp_flags)
            exit
            if isNullScan(pkt.tcp_flags)
                puts "NULL"
            elsif isFinScan(pkt.tcp_flags)
                puts "FIN"
            elsif isXmasScan(pkt.tcp_flags)
                puts "XMAS"
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

main
