# frozen_string_literal: true

require 'find'
require './09.wc_object/calculation'
require './09.wc_object/file'
require './09.wc_object/output'

if $stdin.stat.mode.to_s(8)[0] == '1'
  Output.output_with_stdin
else
  Output.output_without_stdin
end
