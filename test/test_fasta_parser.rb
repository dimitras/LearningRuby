require "fasta_parser"
require "test/unit"
 
class TestFastaParser < Test::Unit::TestCase
 	
	def setup
	   @fp = FastaParser.open("test/fasta10entries.fna")
	   counter = 0
	   @fp.each do |entry|
	   		if counter == 1  ### to check each method ###
		   		@entry = entry
		   	end
	   		counter +=1
	   end
	end


	def test_entries_number
		assert_equal(10, @fp.count())
	end


	def test_entry
		assert_equal("197313646", @fp.first.gi)
		assert_equal("149944479", @fp.last.gi)
		assert_equal("197313649", @fp.entry(2).gi)
		assert_equal(992, @fp.first.seq.length)
	end	


	def test_each
		assert_equal("197313649", @entry.gi)
	end
 
end