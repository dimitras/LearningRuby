class FastaParser
	attr_accessor :filename, :filehandle, :count, :entrypos

	def initialize(filename, filehandle)
		@filename = filename
		@filehandle = filehandle
		@count = 0
		@entrypos = []
	end

	def increment()
		@count += 1
	end

 	def push_entry_pos(position)
 		@entrypos << position
 	end
	
	def first()
		return self.entry(1)
	end

	def last()
		return self.entry(@entrypos.length)
	end

	def entry(entryno)
		self.filehandle.pos = @entrypos[entryno-1] # using 1-based numbering scheme
		line = self.filehandle.readline.chomp
		line =~ />gi\|(.+)\|ref\|(.+)\|(.+)/
		gi, accno, desc, seq = $1, $2, $3, ''
		self.filehandle.each do |line|
			line = line.chomp
			if (line[0..0] == ">")
				break
			end
			seq = seq + line
		end
		return Entry.new(gi, accno, desc, seq)
	end

	### first way ###
	def self.open(filename)
		fp = FastaParser.new(filename,File.new(filename))
		if block_given?
			gi,accno,desc,seq = '','','',''
			pos = fp.filehandle.pos
			fp.filehandle.each do |line|
				line = line.chomp
				if ((line[0..0] == ">") and (gi == ''))
					fp.push_entry_pos(pos)
					line =~ />gi\|(.+)\|ref\|(.+)\|(.+)/
					gi, accno, desc, seq = $1, $2, $3, ''
				elsif (line[0..0] == ">")
					fp.push_entry_pos(pos)
					entry = Entry.new(gi, accno, desc, seq)
					yield entry
					fp.increment
					line =~ />gi\|(.+)\|ref\|(.+)\|(.+)/
					gi, accno, desc, seq = $1, $2, $3, ''
				else
					seq += line
					pos = fp.filehandle.pos
				end
			end
			entry = Entry.new(gi, accno, desc, seq)
			yield entry
			fp.increment
		else
			return fp
		end
	end
	### second way ###
	def each()
		gi,accno,desc,seq = '','','',''
		pos = self.filehandle.pos
		self.filehandle.each do |line|
			line = line.chomp
			if ((line[0..0] == ">") and (gi == ''))
				self.push_entry_pos(pos)
				line =~ />gi\|(.+)\|ref\|(.+)\|(.+)/
				gi, accno, desc, seq = $1, $2, $3, ''
			elsif (line[0..0] == ">")
				self.push_entry_pos(pos)
				entry = Entry.new(gi, accno, desc, seq)
 				yield entry
				self.increment
				line =~ />gi\|(.+)\|ref\|(.+)\|(.+)/
				gi, accno, desc, seq = $1, $2, $3, ''
			else
				seq += line
				pos = self.filehandle.pos
			end
		end
		### my last entry ###
		entry = Entry.new(gi, accno, desc, seq)
		yield entry
		self.increment
	end
end

class Entry
       attr_accessor :gi, :accno, :desc, :seq

       def initialize(gi, accno, desc, seq)
               @gi = gi
               @accno = accno
               @desc = desc
               @seq = seq
       end
end

### first way ###
#FastaParser.open(ARGV[0]) do |entry|
#          puts "gi:" + entry.gi
# 	  		 puts "accno:" + entry.accno
#          puts "desc:" + entry.desc
#          puts "seq:" + entry.seq + "\n"
#end
#puts "\n###########################################\n\n"

### second way ###
# fp = FastaParser.open(ARGV[0])
# fp.each do |entry|
# 	puts "gi:" + entry.gi
# 	puts "accno:" + entry.accno
# 	puts "desc:" + entry.desc
# 	puts "seq:" + entry.seq
# 	puts "\n"
# end

# ### extra functions ###
# puts "COUNT: " + fp.count.to_s
# puts "FIRST ENTRY: " + fp.first.gi + "\n" + fp.first.accno + "\n" + fp.first.desc + "\n" + fp.first.seq
# puts "LAST ENTRY: " + fp.last.gi + "\n" + fp.last.accno + "\n" + fp.last.desc + "\n" + fp.last.seq

# entryno = 2
# puts "ENTRY#{entryno}: " + fp.entry(entryno).gi + "\n" + fp.entry(entryno).accno + "\n" + fp.entry(entryno).desc + "\n" + fp.entry(entryno).seq
