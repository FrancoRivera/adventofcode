# frozen_string_literal: true

# 1 part 1

puts 'Day 1'
answer = 0
[125_860, 66_059, 147_392, 64_447, 72_807, 136_018, 144_626, 68_233, 130_576, 92_645, 52_805, 79_642, 74_361, 98_270, 110_796, 62_578, 58_421, 125_079, 52_683, 144_885, 148_484, 113_638, 125_026, 112_534, 125_479, 51_539, 122_007, 60_048, 67_923, 76_115, 144_822, 115_991, 133_505, 85_249, 142_441, 90_211, 87_022, 68_196, 117_577, 58_112, 116_865, 108_253, 127_674, 93_302, 58_817, 126_794, 89_824, 134_386, 99_700, 125_855, 119_753, 64_456, 68_167, 88_047, 127_864, 146_890, 71_912, 128_375, 134_365, 91_544, 104_179, 84_700, 95_937, 78_409, 94_604, 130_423, 98_348, 87_489, 105_103, 94_794, 123_723, 134_298, 88_283, 59_543, 53_645, 89_325, 109_301, 143_668, 96_250, 130_371, 140_436, 95_857, 98_543, 91_372, 137_056, 142_578, 116_185, 96_588, 93_025, 122_275, 99_201, 110_492, 109_700, 106_755, 120_979, 60_957, 134_983, 130_840, 132_329, 65_057].each { |m| answer += m / 3 - 2 }
puts answer

# 1 part 2

def get_fuel(mass)
  val = mass / 3 - 2
  return 0 if val <= 0

  val + get_fuel(val)
end
[125_860, 66_059, 147_392, 64_447, 72_807, 136_018, 144_626, 68_233, 130_576, 92_645, 52_805, 79_642, 74_361, 98_270, 110_796, 62_578, 58_421, 125_079, 52_683, 144_885, 148_484, 113_638, 125_026, 112_534, 125_479, 51_539, 122_007, 60_048, 67_923, 76_115, 144_822, 115_991, 133_505, 85_249, 142_441, 90_211, 87_022, 68_196, 117_577, 58_112, 116_865, 108_253, 127_674, 93_302, 58_817, 126_794, 89_824, 134_386, 99_700, 125_855, 119_753, 64_456, 68_167, 88_047, 127_864, 146_890, 71_912, 128_375, 134_365, 91_544, 104_179, 84_700, 95_937, 78_409, 94_604, 130_423, 98_348, 87_489, 105_103, 94_794, 123_723, 134_298, 88_283, 59_543, 53_645, 89_325, 109_301, 143_668, 96_250, 130_371, 140_436, 95_857, 98_543, 91_372, 137_056, 142_578, 116_185, 96_588, 93_025, 122_275, 99_201, 110_492, 109_700, 106_755, 120_979, 60_957, 134_983, 130_840, 132_329, 65_057].each { |m| answer += get_fuel(m) }
puts answer

puts '========================'
puts 'Day 2'
# 2 part 1
arr = [1, 12, 2, 3, 1, 1, 2, 3, 1, 3, 4, 3, 1, 5, 0, 3, 2, 1, 13, 19, 2, 9, 19, 23, 1, 23, 6, 27, 1, 13, 27, 31, 1, 31, 10, 35, 1, 9, 35, 39, 1, 39, 9, 43, 2, 6, 43, 47, 1, 47, 5, 51, 2, 10, 51, 55, 1, 6, 55, 59, 2, 13, 59, 63, 2, 13, 63, 67, 1, 6, 67, 71, 1, 71, 5, 75, 2, 75, 6, 79, 1, 5, 79, 83, 1, 83, 6, 87, 2, 10, 87, 91, 1, 9, 91, 95, 1, 6, 95, 99, 1, 99, 6, 103, 2, 103, 9, 107, 2, 107, 10, 111, 1, 5, 111, 115, 1, 115, 6, 119, 2, 6, 119, 123, 1, 10, 123, 127, 1, 127, 5, 131, 1, 131, 2, 135, 1, 135, 5, 0, 99, 2, 0, 14, 0]

(0..(arr.count / 4)).each do |i|
  if i * 4 > arr.count || i * 4 + 1 > arr.count || i * 4 + 2 > arr.count || i * 4 + 3 > arr.count
    next
  end

  pos_1 = arr[arr[i * 4 + 1]]
  pos_2 = arr[arr[i * 4 + 2]]
  rep = arr[i * 4 + 3]
  if arr[i * 4] == 1
    arr[rep] = pos_1 + pos_2
    next
  elsif arr[i * 4] == 2
    arr[rep] = pos_1 * pos_2
    next
  elsif arr[i * 4] == 99
    puts 'ENDED PROGRAM: ' + arr[0].to_s
    break
  else
    puts 'ERROR'
  end
end

# 2 part 2

arr = [1, 12, 2, 3, 1, 1, 2, 3, 1, 3, 4, 3, 1, 5, 0, 3, 2, 1, 13, 19, 2, 9, 19, 23, 1, 23, 6, 27, 1, 13, 27, 31, 1, 31, 10, 35, 1, 9, 35, 39, 1, 39, 9, 43, 2, 6, 43, 47, 1, 47, 5, 51, 2, 10, 51, 55, 1, 6, 55, 59, 2, 13, 59, 63, 2, 13, 63, 67, 1, 6, 67, 71, 1, 71, 5, 75, 2, 75, 6, 79, 1, 5, 79, 83, 1, 83, 6, 87, 2, 10, 87, 91, 1, 9, 91, 95, 1, 6, 95, 99, 1, 99, 6, 103, 2, 103, 9, 107, 2, 107, 10, 111, 1, 5, 111, 115, 1, 115, 6, 119, 2, 6, 119, 123, 1, 10, 123, 127, 1, 127, 5, 131, 1, 131, 2, 135, 1, 135, 5, 0, 99, 2, 0, 14, 0]
arr_save = Marshal.load(Marshal.dump(arr))

(0...99).each do |j|
  (0...99).each do |k|
    arr = Marshal.load(Marshal.dump(arr_save))
    arr[1] = j
    arr[2] = k
    (0..(arr.count / 4)).each do |i|
      if i * 4 > arr.count || i * 4 + 1 > arr.count || i * 4 + 2 > arr.count || i * 4 + 3 > arr.count
        next
      end

      pos_1 = arr[arr[i * 4 + 1]]
      pos_2 = arr[arr[i * 4 + 2]]
      rep = arr[i * 4 + 3]
      if arr[i * 4] == 1
        arr[rep] = pos_1 + pos_2
        next
      elsif arr[i * 4] == 2
        arr[rep] = pos_1 * pos_2
        next
      elsif arr[i * 4] == 99
        if arr[0] == 19_690_720
          puts 'ENDED PROGRAM: ' + (100 * arr[1] + arr[2]).to_s
          break
        end
      else
        puts 'ERROR'
      end
    end
  end
end
puts '========================'
puts 'Day 3'

input1 = %w[R1001 D915 R511 D336 L647 D844 R97 D579 L336 U536 L645 D448 R915 D473 L742 D470 R230 D558 R214 D463 L374 D450 R68 U625 L937 D135 L860 U406 L526 U555 R842 D988 R819 U995 R585 U218 L516 D756 L438 U921 R144 D62 R238 U144 R286 U934 L682 U13 L287 D588 L880 U630 L882 D892 R559 D696 L329 D872 L946 U219 R593 U536 R402 U946 L866 U690 L341 U729 R84 U997 L579 D609 R407 D846 R225 U953 R590 U79 R590 U725 L890 D384 L442 D364 R600 D114 R39 D962 R413 U698 R762 U520 L180 D557 R35 U902 L476 U95 R830 U858 L312 U879 L85 U620 R505 U248 L341 U81 L323 U296 L53 U532 R963 D30 L380 D60 L590 U699 R967 U88 L725 D730 R706 D337 L248 D46 R131 U541 L313 U508 R120 D719 R28 U342 R555 U780 R397 D523 L619 D820 R865 D4 L790 D544 L873 D249 L220 U343 R818 U803 R309 D576 R811 D717 L800 D171 R523 U630 L854 U265 R207 U147 R518 U237 R822 D672 L140 U580 R408 D739 L519 U759 R664 D61 R258 D313 R472 U437 R975 U828 L54 D892 L370 U509 L80 U593 L268 U856 L177 U950 L266 U29 R493 D228 L110 U390 L92 U8 L288 U732 R459 D422 R287 D359 R915 U295 R959 U215 R82 D357 L970 D782 L653 U399 L50 D720 R788 D396 L562 D560 R798 D196 R79 D732 R332 D957 L106 D199 R756 U379 R716 U282 R812 U346 R592 D416 L454 U612 L160 U884 R373 U306 R55 D492 R175 D233 L249 D616 L342 D650 L181 U868 L761 D170 L976 U711 R377 D113 L548 U39 R62 D99 R853 U249 L951 U617 R257 U457 R430 D355 L541 U595 L176 D987 R365 D77 L181 D192 L688 D942 R617 U484 R247 U180 R771 D392 R184 U597 L682 U454 R856 U616 R174 U629 L607 U41 L970 D602 R402 D208 R826]
input2 = %w[L994 U238 R605 U233 L509 U81 R907 U880 R666 D86 R6 U249 R345 D492 L912 U770 L827 D107 R988 D525 L471 U706 R31 U485 R835 D778 R419 D461 L937 D740 R559 U309 L379 U385 R828 D698 R276 U914 L911 U969 R282 D365 L43 D911 R256 D592 L451 U162 L829 D564 R349 U279 R19 D110 R259 D551 L172 D899 L924 D819 R532 U737 L794 U995 R168 D359 R847 U426 R224 U984 L929 D531 L797 U292 L332 D280 R317 D648 R776 D52 R916 U363 R919 U890 R583 U961 L89 D680 L894 D226 L83 U68 R551 U413 R259 D468 L702 U453 L128 U986 R238 U805 R431 U546 R944 D142 R677 D783 R336 D220 R40 U391 R5 D760 L963 D764 R653 U932 R473 U311 L189 D883 R216 U391 L634 U275 L691 U975 R130 D543 L163 U736 R964 U729 R752 D531 R90 D471 R687 D341 R441 U562 R570 U278 R570 U177 L232 U781 L874 U258 R180 D28 R916 D395 R96 U954 L222 U578 L394 U775 L851 D18 L681 D912 L761 U945 L866 D12 R420 D168 R490 U679 R521 D91 L782 U583 L823 U656 L365 D517 R319 U725 L824 D531 L747 U822 R893 D162 L11 D913 L295 D65 L393 D351 L432 U828 L131 D384 R311 U381 L26 D635 L180 D395 L576 D836 R548 D820 L219 U749 L64 D2 L992 U104 L501 U247 R693 D862 R16 U346 R332 U618 R387 U4 L206 U943 R734 D164 R771 U17 L511 D475 L75 U965 R116 D627 R243 D77 R765 D831 L51 U879 R207 D500 R289 U749 R206 D850 R832 U407 L985 U514 R290 U617 L697 U812 L633 U936 R214 D447 R509 D585 R787 D500 R305 D598 R866 U781 L771 D350 R558 U669 R284 D686 L231 U574 L539 D337 L135 D751 R315 D344 L694 D947 R118 U377 R50 U181 L96 U904 L776 D268 L283 U233 L757 U536 L161 D881 R724 D572 R322]

min_distance = 9_999_999_999
x_pos = 0
y_pos = 0

input1.each do |move|
  _x_pos = x_pos
  _y_pos = y_pos
  case move[0]
  when 'R'
    x_pos += move[1..-1].to_i
  when 'L'
    x_pos -= move[1..-1].to_i
  when 'U'
    y_pos += move[1..-1].to_i
  when 'D'
    y_pos -= move[1..-1].to_i
  else
    puts 'ERROR IN INPUT'
  end

  x2_pos = y2_pos = 0

  input2.each do |move2|
    _x2_pos = x2_pos
    _y2_pos = y2_pos
    case move2[0]
    when 'R'
      x2_pos += move2[1..-1].to_i
    when 'L'
      x2_pos -= move2[1..-1].to_i
    when 'U'
      y2_pos += move2[1..-1].to_i
    when 'D'
      y2_pos -= move2[1..-1].to_i
    else
      puts 'ERROR IN INPUT'
    end

    # horizontal change
    dist = 99_999_999_999_999_999_999
    if x2_pos != _x2_pos
      if (_x2_pos >= x_pos && x2_pos <= x_pos || _x2_pos <= x_pos && x2_pos >= x_pos) && (y2_pos <= y_pos && y2_pos >= _y_pos)
        dist = x_pos.abs + y2_pos.abs
        puts 'They collided Distance horizontally! distance:' + dist.to_s
      end
    else
      if (_y2_pos >= y_pos && y2_pos <= y_pos || _y2_pos <= y_pos && y2_pos >= y_pos) && (x2_pos <= x_pos && x2_pos >= _x_pos)
        dist = y_pos.abs + x2_pos.abs
        puts 'They collided Distance vertically! distance:' + dist.to_s
      end
    end
    min_distance = dist if min_distance > dist && dist != 0
  end
end
puts 'Minimum Distance ever is ' + min_distance.to_s

# part 2

input1 = %w[R1001 D915 R511 D336 L647 D844 R97 D579 L336 U536 L645 D448 R915 D473 L742 D470 R230 D558 R214 D463 L374 D450 R68 U625 L937 D135 L860 U406 L526 U555 R842 D988 R819 U995 R585 U218 L516 D756 L438 U921 R144 D62 R238 U144 R286 U934 L682 U13 L287 D588 L880 U630 L882 D892 R559 D696 L329 D872 L946 U219 R593 U536 R402 U946 L866 U690 L341 U729 R84 U997 L579 D609 R407 D846 R225 U953 R590 U79 R590 U725 L890 D384 L442 D364 R600 D114 R39 D962 R413 U698 R762 U520 L180 D557 R35 U902 L476 U95 R830 U858 L312 U879 L85 U620 R505 U248 L341 U81 L323 U296 L53 U532 R963 D30 L380 D60 L590 U699 R967 U88 L725 D730 R706 D337 L248 D46 R131 U541 L313 U508 R120 D719 R28 U342 R555 U780 R397 D523 L619 D820 R865 D4 L790 D544 L873 D249 L220 U343 R818 U803 R309 D576 R811 D717 L800 D171 R523 U630 L854 U265 R207 U147 R518 U237 R822 D672 L140 U580 R408 D739 L519 U759 R664 D61 R258 D313 R472 U437 R975 U828 L54 D892 L370 U509 L80 U593 L268 U856 L177 U950 L266 U29 R493 D228 L110 U390 L92 U8 L288 U732 R459 D422 R287 D359 R915 U295 R959 U215 R82 D357 L970 D782 L653 U399 L50 D720 R788 D396 L562 D560 R798 D196 R79 D732 R332 D957 L106 D199 R756 U379 R716 U282 R812 U346 R592 D416 L454 U612 L160 U884 R373 U306 R55 D492 R175 D233 L249 D616 L342 D650 L181 U868 L761 D170 L976 U711 R377 D113 L548 U39 R62 D99 R853 U249 L951 U617 R257 U457 R430 D355 L541 U595 L176 D987 R365 D77 L181 D192 L688 D942 R617 U484 R247 U180 R771 D392 R184 U597 L682 U454 R856 U616 R174 U629 L607 U41 L970 D602 R402 D208 R826]
input2 = %w[L994 U238 R605 U233 L509 U81 R907 U880 R666 D86 R6 U249 R345 D492 L912 U770 L827 D107 R988 D525 L471 U706 R31 U485 R835 D778 R419 D461 L937 D740 R559 U309 L379 U385 R828 D698 R276 U914 L911 U969 R282 D365 L43 D911 R256 D592 L451 U162 L829 D564 R349 U279 R19 D110 R259 D551 L172 D899 L924 D819 R532 U737 L794 U995 R168 D359 R847 U426 R224 U984 L929 D531 L797 U292 L332 D280 R317 D648 R776 D52 R916 U363 R919 U890 R583 U961 L89 D680 L894 D226 L83 U68 R551 U413 R259 D468 L702 U453 L128 U986 R238 U805 R431 U546 R944 D142 R677 D783 R336 D220 R40 U391 R5 D760 L963 D764 R653 U932 R473 U311 L189 D883 R216 U391 L634 U275 L691 U975 R130 D543 L163 U736 R964 U729 R752 D531 R90 D471 R687 D341 R441 U562 R570 U278 R570 U177 L232 U781 L874 U258 R180 D28 R916 D395 R96 U954 L222 U578 L394 U775 L851 D18 L681 D912 L761 U945 L866 D12 R420 D168 R490 U679 R521 D91 L782 U583 L823 U656 L365 D517 R319 U725 L824 D531 L747 U822 R893 D162 L11 D913 L295 D65 L393 D351 L432 U828 L131 D384 R311 U381 L26 D635 L180 D395 L576 D836 R548 D820 L219 U749 L64 D2 L992 U104 L501 U247 R693 D862 R16 U346 R332 U618 R387 U4 L206 U943 R734 D164 R771 U17 L511 D475 L75 U965 R116 D627 R243 D77 R765 D831 L51 U879 R207 D500 R289 U749 R206 D850 R832 U407 L985 U514 R290 U617 L697 U812 L633 U936 R214 D447 R509 D585 R787 D500 R305 D598 R866 U781 L771 D350 R558 U669 R284 D686 L231 U574 L539 D337 L135 D751 R315 D344 L694 D947 R118 U377 R50 U181 L96 U904 L776 D268 L283 U233 L757 U536 L161 D881 R724 D572 R322]

# input1 = %w[R75 D30 R83 U83 L12 D49 R71 U7 L72]
# input2 = %w[U62 R66 U55 R34 D71 R55 D58 R83]

min_distance = 9_999_999_999
x_pos = 0
y_pos = 0
steps = steps2 = 0
min_steps = 9_999_999_999_999

input1.each do |move|
  _x_pos = x_pos
  _y_pos = y_pos
  case move[0]
  when 'R'
    x_pos += move[1..-1].to_i
  when 'L'
    x_pos -= move[1..-1].to_i
  when 'U'
    y_pos += move[1..-1].to_i
  when 'D'
    y_pos -= move[1..-1].to_i
  else
    puts 'ERROR IN INPUT'
  end
  steps += move[1..-1].to_i

  x2_pos = y2_pos = 0
  steps2 = 0

  input2.each do |move2|
    _x2_pos = x2_pos
    _y2_pos = y2_pos
    case move2[0]
    when 'R'
      x2_pos += move2[1..-1].to_i
    when 'L'
      x2_pos -= move2[1..-1].to_i
    when 'U'
      y2_pos += move2[1..-1].to_i
    when 'D'
      y2_pos -= move2[1..-1].to_i
    else
      puts 'ERROR IN INPUT'
    end

    steps2 += move2[1..-1].to_i

    # horizontal change
    dist = 99_999_999_999_999_999_999
    if x2_pos != _x2_pos
      if (_x2_pos >= x_pos && x2_pos <= x_pos || _x2_pos <= x_pos && x2_pos >= x_pos) && (y2_pos <= y_pos && y2_pos >= _y_pos)
        _steps2 = steps2 - move2[1..-1].to_i
        _steps2 += (x_pos - _x2_pos).abs
        _steps = steps - move[1..-1].to_i
        _steps += (y2_pos - _y_pos).abs
        next if x_pos.zero? && y2_pos.zero?

        min_steps = _steps2 + _steps if min_steps >= _steps2 + _steps
        dist = x_pos.abs + y2_pos.abs
      end
    else
      if (_y2_pos >= y_pos && y2_pos <= y_pos || _y2_pos <= y_pos && y2_pos >= y_pos) && (x2_pos <= x_pos && x2_pos >= _x_pos)
        _steps2 = steps2 - move2[1..-1].to_i
        _steps2 += (y_pos - _y2_pos).abs
        _steps = steps - move[1..-1].to_i
        _steps += (x2_pos - _x_pos).abs
        next if y_pos.zero? && x2_pos.zero?

        min_steps = _steps2 + _steps if min_steps >= _steps2 + _steps
        dist = y_pos.abs + x2_pos.abs
      end
    end
    min_distance = dist if min_distance > dist && dist != 0
  end
end
puts 'Minimum Distance ever is ' + min_distance.to_s
puts 'Minimum Steps ever is ' + min_steps.to_s

puts '========================'
puts 'Day 4'

def valid?(number)
  valid = false
  last = 0
  # check if they never decrease
  number.to_s.split('').each do |d|
    return false if d.to_i < last

    valid = true if last == d.to_i

    last = d.to_i
  end
  valid
end

count = 0
(353_096..843_212).each do |e|
  count += 1 if valid?(e)
end

puts "Valid passwords #{count}"

puts 'Part 2'

def valid_extended?(number)
  valid2 = 0
  last = 0
  repeating = 1
  # check if they never decrease
  number.to_s.split('').each do |d|
    return false if d.to_i < last

    if last == d.to_i
      repeating += 1
    else
      repeating = 1
    end

    if repeating == 2
      valid2 = d.to_i if valid2.zero?
    elsif repeating > 2
      valid2 = 0 if d.to_i == valid2
    end

    last = d.to_i
  end
  valid2 != 0
end

count = 0
(353_096..843_212).each do |e|
  count += 1 if valid_extended?(e)
end

puts "Valid passwords #{count}"

