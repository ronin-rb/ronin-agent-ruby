if $0 == __FILE__
  def usage
    puts "usage: ruby #{$0} {--http PORT [HOST] | --listen PORT [HOST] | --connect HOST PORT}"
    exit -1
  end

  case ARGV[0]
  when '--http'    then Agent::HTTP::Server.start(ARGV[1],ARGV[2])
  when '--listen'  then Agent::TCP::Server.start(ARGV[1],ARGV[2])
  when '--connect' then Agent::TCP::ConnectBack.start(ARGV[1],ARGV[2])
  else
    usage
  end
end