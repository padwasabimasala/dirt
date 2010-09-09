require 'dirt'
require 'mechanize'
require 'fileutils'

module Dirt
  module WritePages
    DIR = File.expand_path(File.dirname(__FILE__) + '/../../pages')
    FileUtils.mkdir_p(DIR) if !File.exist? DIR
    def get(*args)
      @page_cnt ||= 1
      url = args.is_a?(Hash) ? args[:url] : args.first
      page = super(*args)
      ext, content = page ? [:html, page.body] : [:nil, nil]
      fname = "#{DIR}/#{@page_cnt}.#{ext}"
      File.open(fname, 'w') {|f| f.write(content)}
      @page_cnt += 1
      page
    end
  end

  module LogGets
    def get(*args)
      url = args.is_a?(Hash) ? args[:url] : args.first
      STDERR.puts url
      super(*args)
    end
  end

  class Agent < Mechanize
    include WritePages
    include LogGets
  end
end

