require "lib/fastq_parser"
require "test/unit"
 
class TestFastqParser < Test::Unit::TestCase
 	
	def setup
	   @fqp = FastqParser.open("test/data/fastq_10entries.fq")
	   counter = 1
	   @fqp.each do |entry|
		if counter == 2
			@entry = entry
		end
		counter +=1
	   end
	end	
	
	def test_each
		assert_equal("HWI-ST628:191:c0299abxx:1:1101:1030:2115 1:N:0:CGATGT", @entry.header)
	end
	
	def test_to_fasta
		assert_equal(">HWI-ST628:191:c0299abxx:1:1101:1030:2115 1:N:0:CGATGT\nTGCACAGACACACACACAAACACATGACGTGCATACACACACACTTGTATACAGACATAA\nACATACACACACATTTATACATGCATAAACACACACAAAC", @entry.to_fasta)
	end
	
	def test_entries_number
		assert_equal(10, @fqp.count())
	end


	def test_entry
		assert_equal("HWI-ST628:191:c0299abxx:1:1101:1010:2080 1:Y:0:CGATGT", @fqp.first.header)
		assert_equal("HWI-ST628:191:c0299abxx:1:1101:1247:2229 1:N:0:CGATGT", @fqp.last.header)
		assert_equal("HWI-ST628:191:c0299abxx:1:1101:1030:2115 1:N:0:CGATGT", @fqp.entry(2).header)
		assert_equal(100, @fqp.first.seq.length)
	end
 
end