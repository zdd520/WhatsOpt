require 'test_helper'
require 'whats_opt/openmdao_generator'
require 'whats_opt/openmdao_mapping'
require 'tmpdir'

class OpenmdaoGeneratorTest < ActiveSupport::TestCase

  def setup
    @mda = multi_disciplinary_analyses(:cicav)
    @ogen = WhatsOpt::OpenmdaoGenerator.new(@mda)
  end
    
  test "should generate openmdao component for a given discipline an mda" do
    Dir.mktmpdir do |dir|
      disc = @mda.disciplines[0]
      filepath = @ogen._generate_discipline disc, dir
      assert File.exists?(filepath)
    end
  end
  
  test "should generate openmdao process for an mda" do
    Dir.mktmpdir do |dir|
      filepath = @ogen._generate_mda dir
      assert File.exists?(filepath)
    end
  end
  
  test "should maintain a list of generated filepaths" do
    Dir.mktmpdir do |dir|
      filepath = @ogen._generate_mda dir
      basenames = @ogen.genfiles.map {|fp| File.basename(fp)}.sort
      expected = ["aerodynamics.py", "cicav.py", "geometry.py"]
      assert_equal expected, basenames
    end
  end 
  
  test "should generate openmdao mda zip file" do
    zippath = Tempfile.new('test_mda_file.zip')
    File.open(zippath, 'w') do |f|
      stringio, _ = @ogen.generate
      f.write stringio.read
    end
    assert File.exists?(zippath)
    Zip::File.open(zippath) do |zip|
      zip.each do |entry|
        assert entry.file?
        assert entry.get_input_stream.read =~
          Regexp.new(Regexp.escape('generated by WhatsOpt'), Regexp::MULTILINE)
      end
    end
  end 
  
  test "should run openmdao check and return false when invalid" do
    ok, log = @ogen.check_mda_setup
    refute ok  # check raises a runtime error
    assert_match /Error: Variable name .* already exists/, log.join(' ')
  end
  
  test "should run openmdao check and return true when valid" do
    mda = multi_disciplinary_analyses(:fast)
    ogen2 = WhatsOpt::OpenmdaoGenerator.new(mda)
    ok, log = ogen2.check_mda_setup
    assert ok  # ok even if discipline without connections
    #assert_empty log
  end
  
end