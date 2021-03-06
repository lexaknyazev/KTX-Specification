#!/usr/bin/env ruby
# Copyright (c) 2020 The Khronos Group Inc.
# SPDX-License-Identifier: Apache-2.0

require 'fileutils'
require 'json'
formats = JSON.parse(File.read('formats.json'), :symbolize_names => true).freeze
targets = [:glFormat, :glType, :glInternalFormat, :dxgiFormat, :mtlFormat].freeze
HEADER = %{// Copyright 2020 The Khronos Group Inc.
// SPDX-License-Identifier: Apache-2.0

/*************************************** Do not edit ***************************************
                                  Automatically generated by
  https://github.com/KhronosGroup/KTX-Specification/blob/master/generate_format_switches.rb
 *******************************************************************************************/
}

dir = FileUtils.mkdir_p(ARGV.fetch(0, 'out'))[0]
files = targets.map { |t| [t, File.open("#{dir}/vkFormat2#{t}.inl", 'w')] }.to_h.freeze
files.values.each { |file| file << HEADER }
formats.each do |format|
  files.each do |target, file|
    file << "case #{format[:vkFormat]}: return #{format[target]};\n" if format[target]
  end
end
files.values.each(&:close)
