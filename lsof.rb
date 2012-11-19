#!/usr/bin/env ruby

DOT_FILE = File.expand_path("~/Desktop/lsof.dot")
IMAGE_FILE = DOT_FILE + ".png"

class Document
	def initialize
		@applications = []
		processLSOF
	end

	def processLSOF 
		application = nil
		connection = nil

		# Get the LSOF data
		`lsof -Pi -F`.scan(/^(?:c|n|P|TST).*/).each{ |line|
			field, value = line.scan(/(T..|.)(.*)/).flatten

			case field
				when "c"
					application = Application.new(:name=>value)
					@applications.push(application)
				when "P"
					connection = Connection.new(:protocol=>value)
					application.connections.push(connection)
				when "n"
					connection.processLSOF(value)
				when "TST"
					connection.status = value
			end
		}
	end

	def print stream=STDOUT, depth=0
		stream.puts "digraph G {"
		stream.puts "	overlap=false;"
		stream.puts "	rankdir=LR;"
		stream.puts "	"
		stream.puts %{"My Computer" [shape=box,style=filled,color="#dddddd"];}

		@applications.each { |application| 
			stream.puts %{"My Computer" -> "#{application.name}";}
			application.print(stream, depth+1) 
		}

		stream.puts "}"
	end
end

class Application
	def initialize options={}
		@name = options[:name] || ""
		@connections = []
	end

	def name        ; return @name        ; end
	def connections ; return @connections ; end
	
	def print stream=STDOUT, depth=0
		indent = "\t" * depth
		stream.puts %{#{indent}"#{@name}" [shape="ellipse",style=filled,color="#ddddff"];}
		printedConnections = {}
		printedPorts = {}

		connections.each { |connection| 
			if(!printedConnections[connection.destination]) then
				printedConnections[connection.destination] = true
				stream.puts %{#{indent}\t"#{@name}.#{connection.destination}" [shape=rectangle,label="#{connection.destination}"];}
				stream.puts %{#{indent}\t"#{@name}" -> "#{@name}.#{connection.destination}";}
			end

			if(!printedPorts[connection.destinationPort]) then
				printedPorts[connection.destinationPort] = true
				stream.puts %{#{indent}\t"#{@name}.#{connection.destination}.#{connection.destinationPort}" [shape=plaintext,label="#{connection.destinationPort}"];}
				stream.puts %{#{indent}\t"#{@name}.#{connection.destination}" -> "#{@name}.#{connection.destination}.#{connection.destinationPort}" [label="#{connection.protocol}"];}
			end
		}
	end
end

class Connection
	def initialize options={}
		@protocol    = options[:protocol] || ""
		@source      = ""
		@destination = ""
		@mode        = ""
		@status      = ""
	end
	
	def destination     ; return @destination     ; end
	def destinationPort ; return @destinationPort ; end
	def protocol        ; return @protocol        ; end
	def protocol= value ; @protocol = value       ; end
	def status= value   ; @status = value         ; end
	
	def processLSOF lsofData
		parts = lsofData.scan(/^(?:(.*?):(.*?)\s*->\s*(.*?):(.*?)|(.*?):(.*?))$/)[0]
		@source          = parts[0]
		@sourcePort      = parts[1]
		@destination     = parts[2] || parts[4]
		@destinationPort = parts[3] || parts[5]
	end
end

stream = File.open(DOT_FILE, "w")
Document.new.print stream
stream.close

`dot -Tpng -o "#{IMAGE_FILE}" "#{DOT_FILE}"`
`open "#{IMAGE_FILE}"`

