#:title: FarsiFu
#:include:../README
#:include:../TODO
#:include:../CHANGELOG
#:include:../MIT-LICENSE
module FarsiFu
	
	module NumbersExtensions
		module InstanceMethods
			# :stopdoc:
			$KCODE = 'u' 
			require 'jcode' 
			
			PERSIAN_CHARS = "۱۲۳۴۵۶۷۸۹۰،×؛"
			ENGLISH_CHARS = "1234567890,*;" 
			PERSIAN_DIGIT_JOINT = " و " 
			PERSIAN_DIGIT_SIGN = ["منفی ", "مثبت ", " ممیز "] 
			PERSIAN_DIGIT_SPELL = {
				0 			   => [ nil ,"یک","دو","سه","چهار","پنج","شش","هفت","هشت","نه", "صفر"] ,
				1 			   => [ nil ,"ده","بیست","سی","چهل","پنجاه","شصت","هفتاد","هشتاد","نود"],
				2 			   => [ nil ,"صد","دویست","سیصد","چهارصد","پانصد","ششصد","هفتصد","هشتصد","نهصد"],
				"10..19"   => [ "ده" ,"یازده","دوازده","سیزده","چهارده","پانزده","شانزده","هفده","هشده","نوزده"],
				"zillion"  => [ nil ,"هزار","میلیون","میلیارد","بیلیون","تریلیون","کوادریلیون","کوینتیلیون","سیکستیلیون","سپتیلیون","اکتیلیون","نونیلیون","دسیلیون"],
				"decimals" => [ nil, "دهم", "صدم", "هزارم", "ده‌هزارم", "صدهزارم", "میلیونیم", "ده‌میلیونیم","صدمیلیونیم","میلیاردیم"]
			} 			
			# :startdoc:
			
			# Returns a string which is the equivalent English number of a Persian number (in String) 
			#
			# Example: 
			#
			# <tt>"۱۲۳".to_english # => "123" </tt>
			def to_english
				self.to_s.tr(PERSIAN_CHARS,ENGLISH_CHARS)
			end
			
			# Returns a string which is the equivalent Persian number of an English number (in String) 
			# accepts instances of String, Integer and Numeric classes (Fixnum,Bignum and floats are accepted) 
			#
			# alias: to_persian
			#
			# Example: 
			#
			# <tt>"123".to_farsi # => "۱۲۳" </tt>
			# <tt>"456".to_persian # => "۴۵۶" </tt>
			# <tt> 789.to_farsi # => "۷۸۹" </tt>
			def to_farsi
				self.to_s.tr(ENGLISH_CHARS,PERSIAN_CHARS)	
			end
			
			alias_method :to_persian, :to_farsi	
						
			# Spells a number in Persian 
			# accpets english numbers (in float,fixnum or string) 
			#
			# Example: 
			#
			# <tt> 5678.spell_farsi # => "پنج هزار و ششصد و هفتاد و هشت" </tt>
			def spell_farsi
				# Distigushing the number (float and )
				if self.class == Float
					num_array = self.to_f.to_s.split(".").first.split(//).reverse
					dec_array = self.to_f.to_s.split(".").last.split(//).slice(0..9).compact.reverse
					dec_copy_b = dec_array.clone ; dec_copy_a = dec_array.clone
					result = spell(num_array)
					( result += PERSIAN_DIGIT_SIGN[2] + spell(dec_array) + PERSIAN_DIGIT_SPELL["decimals"][dec_copy_a.size].to_s )  unless [PERSIAN_DIGIT_SPELL[0][10],""].include? spell(dec_copy_b)
					return result
				else
					num_array = self.to_i.to_s.split(//).reverse
					return spell(num_array)
				end
			end

		private #---------------------------------------------------------			
		def spell(num_array)
			# Dealing with signs
			sign_m = num_array.include?("-") ? PERSIAN_DIGIT_SIGN[0] : ""
			sign_p = num_array.include?("+") ? PERSIAN_DIGIT_SIGN[1] : ""
			num_array.delete_at(num_array.index("-")) if sign_m.size > 0
			num_array.delete_at(num_array.index("+")) if sign_p.size > 0
			sign = sign_m + sign_p
			
			zillion = 0
			farsi_number = []

			# Dealing with Zero
			if (num_array.length == 1 && num_array[0] == "0" )
				farsi_number = [PERSIAN_DIGIT_SPELL[0][10]] 
				num_array = []
			end
			
			while num_array.length > 0 do
				spelling = []
				num_array[0..2].each_with_index do |digit,index|
						spelling[index] = PERSIAN_DIGIT_SPELL[index][digit.to_i]
						if index == 1 && digit == "1" 	# Dealing with 10..19
				 			spelling[1] = PERSIAN_DIGIT_SPELL["10..19"][num_array[0].to_i]
					 		spelling[0] = nil
					 	end
				end
				
				3.times { num_array.shift if num_array.length > 0 } # Eliminating the first 3 number of the array
				dig = spelling.reverse.compact.join(PERSIAN_DIGIT_JOINT) 
				if dig.size > 0
					dig << (" " + PERSIAN_DIGIT_SPELL["zillion"][zillion].to_s) 
					farsi_number.unshift(dig) 
				end
				
				zillion += 1
			end # End of While

			sign + farsi_number.compact.join(PERSIAN_DIGIT_JOINT)			
		end

		end
	end	

end

String.send(:include, FarsiFu::NumbersExtensions::InstanceMethods)
Integer.send(:include, FarsiFu::NumbersExtensions::InstanceMethods)
Numeric.send(:include, FarsiFu::NumbersExtensions::InstanceMethods)
#Fixnum.send(:include, FarsiFu::NumbersExtensions::InstanceMethods)
#Float.send(:include, FarsiFu::NumbersExtensions::InstanceMethods)