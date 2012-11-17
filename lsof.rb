#!/usr/bin/env ruby

DOT_FILE = File.expand_path("~/Desktop/lsof.dot")
IMAGE_FILE = DOT_FILE + ".png"

class Node
	def initialize name="", options={}
		@name = name
		@children = {}
		@options = options
	end

	#
	# Properties
	#
	def name     ; return @name     ; end
	def children ; return @children ; end
	def options  ; return @options  ; end

	#
	# Methods
	#
	def addChild node
		return children[node.name] = node
	end

	def print stream=STDOUT, depth=0
		indent = "\t" * depth
		properties = formatOptions @options
		stream.puts %{#{indent}"#{@name}" #{properties};}

		@children.each {|name,child|
			stream.puts %{#{indent}\t"#{@name}" -> "#{name}";}
			child.print stream, depth+1
		}
	end

	def formatOptions options=@options
		result = "["
		options.each {|name,value| result += %{#{name}="#{value}"} }
		result += "]"
		
		return result
	end
end

# Get the LSOF data
lines = `lsof -Pi -F`.scan(/^(?:c|n|P|TST).*/)

# Create a node map so we don't double up nodes
nodes = {}

document = Node.new()
nodes[:document] = document
application = nil

lines.each { |line| 
	field, value = line.scan(/(T..|.)(.*)/).flatten
	
	case field
	when "c" 
		node = document.addChild(Node.new(value))
	when "P" # protocol
		node.options[:protocol] = value
	when "n"
		address = value
	when "TST"
		field, value = value.split("=")
	when "u"
	else
		puts "Unknown field '#{field}' in #{value}"
	end

	if(false) then
		application, pid, protocol, connection = line.scan(/(\w+)\s+(\d+).*?(TCP|UDP) (.*?)$/)[0]
		# Get the name of the application
		application = `lsof -n -p #{pid}`.split("\n")[3]
		
		node = document.children[application] || Node.new(application, :shape=>"ellipse")
		document.addChild node
		
		parts = connection.scan(/((.*)\s*->\s*(.*)\s+\((.*)\)|(.*?)\((.*?)\)|(^.*))/)[0]
		source      = parts[1] || parts[4] || parts[6]
		destination = parts[2] 
		mode        = parts[3] || parts[5]

		if(destination) then
			child = Node.new destination, :shape=>"rectangle"
			node.addChild child
			
			mode_ = mode ? ":#{mode}" : ""
			#file.puts %{\t\t"#{application}" -> "#{destination}" [ label = "#{protocol}#{mode_}" ];}
		end
	end
}

file = File.open(DOT_FILE, "w")
file.puts "digraph G {"
file.puts "\toverlap=false;"
file.puts ""
document.children.each {|name,node| node.print(file, 1) }
file.puts "}"

file.close

`twopi -Tpng -o "#{IMAGE_FILE}" "#{DOT_FILE}"`
#`open "#{IMAGE_FILE}"`

