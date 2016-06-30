# Copyright © Mapotempo, 2015-2016
#
# This file is part of Mapotempo.
#
# Mapotempo is free software. You can redistribute it and/or
# modify since you respect the terms of the GNU Affero General
# Public License as published by the Free Software Foundation,
# either version 3 of the License, or (at your option) any later version.
#
# Mapotempo is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
# or FITNESS FOR A PARTICULAR PURPOSE.  See the Licenses for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with Mapotempo. If not, see:
# <http://www.gnu.org/licenses/agpl.html>
#

class Router < ActiveRecord::Base
  DIMENSION = {time: 0, distance: 1}.freeze

  nilify_blanks
  auto_strip_attributes :name, :url_time, :url_distance, :mode
  validates :name, presence: true
  validates :mode, presence: true

  def speed_multiplicator_zones?
    false
  end

  def trace_batch(speed_multiplicator, segments, dimension = :time, options = {})
    segments.collect{ |segment|
      begin
        trace(speed_multiplicator, *segment, dimension, options)
      rescue RouterError
        [nil, nil, nil]
      end
    }
  end

  private

  def pack_vector(row, column)
    # Sort vector for caching
    i = -1
    row = row.map{ |a| [a[0], a[1], i += 1] }
    row = row.sort!{ |a, b|
      a[0] != b[0] ? a[0] <=> b[0] : a[1] <=> b[1]
    }

    i = -1
    column = column.map{ |a| [a[0], a[1], i += 1] }
    column = column.sort!{ |a, b|
      a[0] != b[0] ? a[0] <=> b[0] : a[1] <=> b[1]
    }

    [row, column]
  end

  def unpack_vector(row, column, matrix)
    # Restore original order
    out = []
    row.size.times{ |i|
      line = []
      column.size.times{ |j|
        line[column[j][2]] = matrix[i][j]
      }
      out[row[i][2]] = line
    }

    out
  end

  def rectangular2square_matrix(row, column, &_block)
    row, column = pack_vector(row, column)
    vector = row != column ? row + column : row
    matrix = yield(vector)
    if row != column
      matrix = matrix[0..row.size - 1].collect{ |l|
        l[row.size..-1]
      }
    end
    unpack_vector(row, column, matrix)
  end

  def matrix_iterate(row, column, speed_multiplicator, dimension = :time, options, &block)
    segments = row.flat_map{ |v1|
      column.collect{ |v2|
        [v1[0], v1[1], v2[0], v2[1]]
      }
    }

    trace_batch(speed_multiplicator, segments, dimension, options).collect{ |distance, time, _trace|
      distance ||= 2147483647
      time ||= 2147483647
      block.call(1, total) if block
      [distance, time]
    }.slice(row.size)
  end

  private

  # Access method after overide in sub classes

  def super_time?
    time?
  end

  def super_distance?
    distance?
  end
end
