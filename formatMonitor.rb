#!/usr/bin/env ruby

require 'digest'

CONFIG_PATH = Dir.glob( File.expand_path("~/*Sett*/uncrustify/uncrustify.cfg") )[0]

if(!CONFIG_PATH) then abort("Cannot find uncrustify configuration") end

class Application
	def initialize
		@files = {}
	end

	def files        ; return @files  ; end
	def files= value ; @files = value ; end

	def run
		i = -1;
		
		# Get the file filters from CLI or default
		fileFilters = (ARGV[0] || "*.*pp,*.h*").split(",")

		# Format all the file filters
		#EX: -name "*.*pp" -or -name "*.h"
		fileFilters.each_index { |i| fileFilters[i] = %{-name "#{fileFilters[i]}"} }
		# Join the filters with -or for `find`
		filters = fileFilters.join(" -or ")

		while(true) do
			i = (i + 1) % 15
			
			# Every 15, get a new file listing
			if(i == 0) then 
				files = `find . -maxdepth 20 #{filters}`.split("\n")
				files.each { |path| touchFile(path) }
			end
			
			files.each { |path| 
				mtime = File.mtime(path)

				if(mtime != @files[path][:mtime]) then
					if(md5(path) != @files[path][:md5]) then
						`uncrustify -c #{CONFIG_PATH} -f "#{path}" -o "#{path}.formatted"`

						if(md5(path) != md5("#{path}.formatted")) then
							`cat "#{path}.formatted" > "#{path}"`
						end

						touchFile(path)
						File.delete("#{path}.formatted")
					end
				end
			}
			
			sleep 1
		end
	end

	def md5 path
		return Digest::MD5.file(path).hexdigest
	end

	def touchFile path
		@files[path] = {
			:mtime => File.mtime(path) , 
			:md5   => md5(path)        , 
		}
	end
end

Application.new.run

