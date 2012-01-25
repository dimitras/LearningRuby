class FastqParser
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
		return self.entry(self.entrypos.length)
	end

	def entry(entryno)
		self.filehandle.pos = @entrypos[entryno-1] # using 1-based numbering scheme
		header = self.filehandle.readline.chomp[1..-1] #-1 is the last index
		seq = self.filehandle.gets.chomp
		extra = self.filehandle.gets.chomp
		qscore_seq = self.filehandle.gets.chomp
		return FastqEntry.new(header, seq, qscore_seq)
	end
	
	def self.open(filename)
		fqp = FastqParser.new(filename,File.new(filename))
		if block_given?
			pos = fqp.filehandle.pos
			fqp.filehandle.each do |line|
				line = line.chomp
				if (line[0..0] == "@")
					fqp.push_entry_pos(pos)
					header = line[1..line.length]
					seq = fqp.filehandle.gets.chomp
					extra = fqp.filehandle.gets.chomp
					qscore_seq = fqp.filehandle.gets.chomp
					entry = FastqEntry.new(header, seq, qscore_seq)
					pos = fqp.filehandle.pos
					fqp.increment
					yield entry
				end
			end
			fqp.push_entry_pos(pos)
		else
			return fqp
		end
	end

	def each()
		pos = self.filehandle.pos
		self.filehandle.each do |line|
			line = line.chomp
			if (line[0..0] == "@")
				self.push_entry_pos(pos)
				header = line[1..line.length]
				seq = self.filehandle.gets.chomp
				extra = self.filehandle.gets.chomp
				qscore_seq = self.filehandle.gets.chomp
				entry = FastqEntry.new(header, seq, qscore_seq)
				pos = self.filehandle.pos
				self.increment
				yield entry
			end
		end
	end
	
	def to_fasta(fastafile)
		fap = File.open(fastafile,"w")
		self.each do |entry|
			fap.puts entry.to_fasta
# 			fap.puts ">" + entry.header
# 			(0..entry.seq.length-1).each do |i|
# 				fap.print entry.seq[i..i]
# 				if (((i+1) % 60 == 0) || ((i+1) == entry.seq.length))
# 					fap.print "\n"
# 				end
# 			end
		end
	end
	
	
end


class FastqEntry
	attr_accessor :header, :seq, :qscore_seq

	def initialize(header, seq, qscore_seq)
		@header = header
		@seq = seq
		@qscore_seq = qscore_seq
	end
	
	def to_fasta()
		fasta = ">" + self.header + "\n"
		(0..self.seq.length-2).each do |i|
			fasta = fasta + self.seq[i..i]
			if ((i+1) % 60 == 0)
				fasta = fasta + "\n"
			end
		end
		fasta = fasta + self.seq[self.seq.length-1..self.seq.length-1]
		return fasta
	end
end


# fqp = FastqParser.open(ARGV[0])
# fqp.to_fasta(ARGV[1])
