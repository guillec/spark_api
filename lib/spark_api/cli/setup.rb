require "rubygems"
require 'pp'
require 'irb/ext/save-history'
IRB.conf[:SAVE_HISTORY] = 1000
IRB.conf[:HISTORY_FILE] = "#{ENV['HOME']}/.spark-api-history"

if ENV["SPARK_API_CONSOLE"].nil?
  require 'spark_api'
else
  puts "Enabling console mode for local gem"
  Bundler.require(:default, "development") if defined?(Bundler)
  path = File.expand_path(File.dirname(__FILE__) + "/../../../lib/")
  $LOAD_PATH.unshift(path) unless $LOAD_PATH.include?(path)
  require path + '/spark_api'
end

IRB.conf[:AUTO_INDENT]=true
IRB.conf[:PROMPT][:SPARK]= {
  :PROMPT_I => "SparkApi:%03n:%i> ",
  :PROMPT_S => "SparkApi:%03n:%i%l ",
  :PROMPT_C => "SparkApi:%03n:%i* ",
  :RETURN => "%s\n"
} 

IRB.conf[:PROMPT_MODE] = :SPARK

path = File.expand_path(File.dirname(__FILE__) + "/../../../lib/")
$LOAD_PATH.unshift(path) unless $LOAD_PATH.include?(path)
require path + '/spark_api'

module SparkApi
  def self.logger
    if @logger.nil?
      @logger = Logger.new(STDOUT)
      @logger.level = ENV["DEBUG"].nil? ? Logger::WARN : Logger::DEBUG
    end
    @logger
  end
end

SparkApi.logger.info("Client configured!")

include SparkApi::Models

def c
  SparkApi.client
end
