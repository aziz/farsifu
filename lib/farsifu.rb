# encoding: UTF-8

#:title: Farsifu
module FarsiFu

  module NumbersExtensions
    module InstanceMethods
      # :stopdoc:
      if RUBY_VERSION < '1.9'
        require 'jcode'
        $KCODE = 'u'
      end
      PERSIAN_CHARS = "۱۲۳۴۵۶۷۸۹۰،؛"
      ENGLISH_CHARS = "1234567890,;"
      PERSIAN_DIGIT_JOINT = " و "
      PERSIAN_DIGIT_SIGN = ["منفی ", "مثبت ", " ممیز "]
      PERSIAN_DIGIT_SPELL = {
        0          => [ nil ,"یک","دو","سه","چهار","پنج","شش","هفت","هشت","نه", "صفر"] ,
        1          => [ nil ,"ده","بیست","سی","چهل","پنجاه","شصت","هفتاد","هشتاد","نود"],
        2          => [ nil ,"صد","دویست","سیصد","چهارصد","پانصد","ششصد","هفتصد","هشتصد","نهصد"],
        "10..19"   => [ "ده" ,"یازده","دوازده","سیزده","چهارده","پانزده","شانزده","هفده","هجده","نوزده"],
        "zillion"  => [ nil ,"هزار","میلیون","میلیارد","بیلیون","تریلیون","کوادریلیون","کوینتیلیون","سیکستیلیون","سپتیلیون","اکتیلیون","نونیلیون","دسیلیون"],
        "decimals" => [ nil, "دهم", "صدم", "هزارم", "ده‌هزارم", "صدهزارم", "میلیونیم", "ده‌میلیونیم","صدمیلیونیم","میلیاردیم"]
      }
      # :startdoc:

      # Returns a string which is the equivalent English number of a Persian number (in String)
      #
      # Example:
      #   "۱۲۳".to_english # => "123"
      def to_english
        self.to_s.tr(PERSIAN_CHARS,ENGLISH_CHARS)
      end

      # Returns a string which is the equivalent Persian number of an English number (in String)
      # accepts instances of String, Integer and Numeric classes (Fixnum,Bignum and floats are accepted)
      #
      # alias: to_persian
      #
      # Example:
      #   "123".to_farsi # => "۱۲۳"
      #   "456".to_persian # => "۴۵۶"
      #   789.to_farsi # => "۷۸۹"
      def to_farsi
        self.to_s.tr(ENGLISH_CHARS,PERSIAN_CHARS)
      end
      alias_method :to_persian, :to_farsi

      # Spells a number in Persian
      # accpets english numbers (in float,fixnum or string)
      #
      # Example:
      #   5678.spell_farsi # => "پنج هزار و ششصد و هفتاد و هشت"
      def spell_farsi
        # Distigushing the number (float and )
        if self.class == Float
          num_array = self.to_f.to_s.split(".").first.split(//).reverse
          dec_array = self.to_f.to_s.split(".").last.split(//).slice(0..9).compact.reverse
          dec_copy_b = dec_array.clone ; dec_copy_a = dec_array.clone
          result = spell(num_array)
          ( result += PERSIAN_DIGIT_SIGN[2] + spell(dec_array) + " " + PERSIAN_DIGIT_SPELL["decimals"][dec_copy_a.size].to_s )  unless [PERSIAN_DIGIT_SPELL[0][10],""].include? spell(dec_copy_b)
          return result
        else
          num_array = self.to_i.to_s.split(//).reverse
          return spell(num_array)
        end
      end

      # Spells numbers in sequentional format. If pass `true`, it will use the second format
      #
      # Example:
      #   1.spell_seq       # => "اول"
      #   121.spell_seq     # => "صد و بیست و یکم"
      #   2.spell_seq(true) # => "دومین"
      #   2054.spell_seq(true) # => "دو هزار و پنجاه چهارمین"
      def spell_seq(*args)
        if args[0]
          exceptions = {0 => "صفر", 1 => "اولین", 3 => "سومین"}
          suffix = "مین"
        else
          exceptions = {0 => "صفر", 1 => "اول", 3 => "سوم"}
          suffix = "م"
        end

        make_sequence_spell(exceptions, suffix)
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
            if index == 1 && digit == "1"   # Dealing with 10..19
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

      sign + farsi_number.compact.join(PERSIAN_DIGIT_JOINT).strip
    end

    def make_sequence_spell(exceptions, suffix)
      if exceptions.include? self
        exceptions[self]
      else
        (spell_farsi + suffix).gsub(/سه(م|مین)$/) { "سو#{$1}" }
      end
    end

    end
  end

end

# Defines some data structures related to Iran
# ==== Provinces
# An array of hashes with information about Iran's provinces. has these keys:
# [:name]         string in Persian
# [:eng_name]     string in English
# [:capital]      string in Persian
# [:eng_capital]  string in English
# [:counties]     array of county names in Persian
#
# ==== Countries
# An array of hashes of the name of countries in the world in Persian and Eglish. has these keys:
# [:iso2] two character code of the country
# [:en]   English name
# [:fa]   Persian name
module Iran

  # :stopdoc:
  Provinces = [
  {:name => "آذربایجان شرقی"     , :eng_name => "Azerbaijan, East",           :capital => "تبریز",   :eng_capital => "Tabriz",      :counties => ["آذرشهر", "اسکو", "اهر", "بستان‌آباد", "بناب", "تبریز", "جلفا", "چاراویماق", "سراب", "شبستر", "عجب‌شیر", "کلیبر", "مراغه", "مرند", "ملکان", "میانه", "ورزقان", "هریس", "هشترود"]},
  {:name => "آذربایجان غربی"     , :eng_name => "Azerbaijan, West",           :capital => "ارومیه",  :eng_capital => "Urmia",       :counties => ["ارومیه", "اشنویه", "بوکان", "پلدشت", "پیرانشهر", "تکاب", "چالدران", "چایپاره", "خوی", "سردشت", "سلماس", "شاهین‌دژ", "شوط", "ماکو", "مهاباد", "میاندوآب", "نقده"]},
  {:name => "اردبیل"             , :eng_name => "Ardabil",                    :capital => "اردبیل",  :eng_capital => "Ardabil",     :counties => ["اردبیل", "بیله‌سوار", "پارس‌آباد", "خلخال", "سرعین", "کوثر", "گرمی", "مشگین‌شهر", "نمین", "نیر"]},
  {:name => "اصفهان"             , :eng_name => "Isfahan",                    :capital => "اصفهان",  :eng_capital => "Isfahan",     :counties => ["اردستان", "اصفهان", "برخوار", "تیران و کرون", "چادگان", "خمینی‌شهر", "خوانسار", "خور و بیابانک", "سمیرم", "شاهین‌شهر و میمه", "شهرضا", "دهاقان", "فریدن", "فریدون‌شهر", "فلاورجان", "كاشان", "گلپایگان", "لنجان", "مبارکه", "نایین", "نجف‌آباد", "نطنز"]},
  {:name => "ایلام"              , :eng_name => "Ilam",                       :capital => "ایلام",   :eng_capital => "Ilam",        :counties => ["آبدانان", "ایلام", "ایوان", "دره‌شهر", "دهلران", "شیروان و چرداول", "ملکشاهی", "مهران"]},
  {:name => "بوشهر"              , :eng_name => "Bushehr",                    :capital => "بوشهر",   :eng_capital => "Bushehr",     :counties => ["بوشهر", "تنگستان", "جم", "دشتستان", "دشتی", "دیر", "دیلم", "کنگان", "گناوه"]},
  {:name => "تهران"              , :eng_name => "Tehran",                     :capital => "تهران",   :eng_capital => "Tehran",      :counties => ["اسلام‌شهر", "پاکدشت", "تهران", "دماوند", "رباط‌کریم", "ری", "ساوجبلاغ", "شمیرانات", "شهریار", "فیروزکوه", "قدس", "کرج", "ملارد", "نظرآباد", "ورامین"]},
  {:name => "چهارمحال و بختیاری" , :eng_name => "Chahar Mahaal and Bakhtiari",:capital => "شهرکرد",  :eng_capital => "Shahrekord",  :counties => ["اردل", "بروجن", "شهرکرد", "فارسان", "کوهرنگ", "کیار", "لردگان"]},
  {:name => "خراسان جنوبی"       , :eng_name => "Khorasan, South",            :capital => "بیرجند",  :eng_capital => "Birjand",     :counties => ["بشرویه", "بیرجند", "درمیان", "سرایان", "سربیشه", "فردوس", "قائنات", "نهبندان"]},
  {:name => "خراسان رضوی"        , :eng_name => "Khorasan, Razavi",           :capital => "مشهد",    :eng_capital => "Mashhad",     :counties => ["بردسکن", "بجستان", "تایباد", "تخت‌جلگه", "تربت جام", "تربت حیدریه", "چناران", "جغتای", "جوین", "خلیل‌آباد", "خواف", "درگز", "رشتخوار", "زاوه", "سبزوار", "سرخس", "فریمان", "قوچان", "طرقبه و شاندیز", "کاشمر", "کلات", "گناباد", "مشهد", "مه‌ولات", "نیشابور"]},
  {:name => "خراسان شمالی"       , :eng_name => "Khorasan, North",            :capital => "بجنورد",  :eng_capital => "Bojnourd",    :counties => ["اسفراین", "بجنورد", "جاجرم", "شیروان", "فاروج", "گرمه", "مانه و سملقان"]},
  {:name => "خوزستان"            , :eng_name => "Khuzestan",                  :capital => "اهواز",   :eng_capital => "Ahvaz",       :counties => ["آبادان", "امیدیه", "اندیکا", "اندیمشک", "اهواز", "ایذه", "باغ‌ملک", "بهبهان", "خرمشهر", "دزفول", "دشت آزادگان", "رامشیر", "رامهرمز", "شادگان", "شوش", "شوشتر", "گتوند", "لالی", "ماهشهر", "مسجدسلیمان", "هفتگل", "هندیجان", "هویزه"]},
  {:name => "زنجان"              , :eng_name => "Zanjan",                     :capital => "زنجان",   :eng_capital => "Zanjan",      :counties => ["ابهر", "ایجرود", "خدابنده", "خرمدره", "زنجان", "طارم", "ماه‌نشان"]},
  {:name => "سمنان"              , :eng_name => "Semnan",                     :capital => "سمنان",   :eng_capital => "Semnan",      :counties => ["دامغان", "سمنان", "شاهرود", "گرمسار", "مهدی‌شهر"]},
  {:name => "سیستان و بلوچستان"  , :eng_name => "Sistan and Baluchistan",     :capital => "زاهدان",  :eng_capital => "Zahedan",     :counties => ["ایرانشهر", "چابهار", "خاش", "دلگان", "زابل", "زابلی", "زاهدان", "زهک", "سراوان", "سرباز", "سیب و سوران", "کنارک", "نیک‌شهر", "هیرمند"]},
  {:name => "فارس"               , :eng_name => "Fars",                       :capital => "شیراز",   :eng_capital => "Shiraz",      :counties => ["آباده", "ارسنجان", "استهبان", "اقلید", "بوانات", "پاسارگاد", "جهرم", "خرم‌بید", "خنج", "داراب", "رستم", "زرین‌دشت", "سپیدان", "سروستان", "شیراز", "فراشبند", "فسا", "فیروزآباد", "قیر و کارزین", "کازرون", "گراش", "لارستان", "لامرد", "مرودشت", "ممسنی", "مهر", "نی‌ریز"]},
  {:name => "قزوین"              , :eng_name => "Qazvin",                     :capital => "قزوین",   :eng_capital => "Qazvin",      :counties => ["آبیک", "البرز", "بویین‌زهرا", "تاکستان", "قزوین"]},
  {:name => "قم"                 , :eng_name => "Qom",                        :capital => "قم",      :eng_capital => "Qom",         :counties => ["قم"]},
  {:name => "کردستان"            , :eng_name => "Kurdistan",                  :capital => "سنندج",   :eng_capital => "Sanandaj",    :counties => ["بانه", "بیجار", "دهگلان", "دیواندره", "سروآباد", "سقز", "سنندج", "قروه", "کامیاران", "مریوان"]},
  {:name => "کرمان"              , :eng_name => "Kerman",                     :capital => "کرمان",   :eng_capital => "Kerman",      :counties => ["بافت", "بردسیر", "بم", "جیرفت", "رابر", "راور", "رفسنجان", "رودبار جنوب", "زرند", "سیرجان", "شهر بابک", "عنبرآباد", "فهرج", "قلعه گنج", "کرمان", "کوهبنان", "کهنوج", "منوجان"]},
  {:name => "کرمانشاه"           , :eng_name => "Kermanshah",                 :capital => "کرمانشاه",:eng_capital => "Kermanshah",  :counties => ["اسلام‌آباد غرب", "پاوه", "ثلاث باباجانی", "جوانرود", "دالاهو", "روانسر", "سرپل ذهاب", "سنقر", "صحنه", "قصر شیرین", "کرمانشاه", "کنگاور", "گیلان غرب", "هرسین"]},
  {:name => "کهگیلویه و بویراحمد", :eng_name => "Kohgiluyeh and Boyer-Ahmad", :capital => "یاسوج",   :eng_capital => "Yasuj",       :counties => ["بویراحمد", "بهمئی", "دنا", "کهگیلویه", "گچساران"]},
  {:name => "گلستان"             , :eng_name => "Golestan",                   :capital => "گرگان",   :eng_capital => "Gorgan",      :counties => ["آزادشهر", "آق‌قلا", "بندر گز", "ترکمن", "رامیان", "علی‌آباد", "کردکوی", "کلاله", "گرگان", "گنبد کاووس", "مراوه‌تپه", "مینودشت"]},
  {:name => "گیلان"              , :eng_name => "Gilan",                      :capital => "رشت",     :eng_capital => "Rasht",       :counties => ["آستارا", "آستانه اشرفیه", "املش", "بندر انزلی", "رشت", "رضوان‌شهر", "رودبار زیتون", "رودسر", "سیاهکل", "شفت", "صومعه‌سرا", "طوالش", "فومن", "لاهیجان", "لنگرود", "ماسال"]},
  {:name => "لرستان"             , :eng_name => "Lorestan",                   :capital => "خرم آباد",:eng_capital => "Khorramabad", :counties => ["ازنا", "الیگودرز", "بروجرد", "پل‌دختر", "خرم‌آباد", "دورود", "دوره", "دلفان", "سلسله", "کوهدشت"]},
  {:name => "مازندران"           , :eng_name => "Mazandaran",                 :capital => "ساری",    :eng_capital => "Sari",        :counties => ["آمل", "بابل", "بابلسر", "بهشهر", "تنکابن", "جویبار", "چالوس", "رامسر", "ساری", "سوادکوه", "فریدون‌کنار", "قائم‌شهر", "گلوگاه", "محمودآباد", "نکا", "نور", "نوشهر"]},
  {:name => "مرکزی"              , :eng_name => "Markazi",                    :capital => "اراک",    :eng_capital => "Arak",        :counties => ["آشتیان", "اراک", "تفرش", "خمین", "خنداب", "دلیجان", "زرندیه", "ساوه", "شازند", "کمیجان", "محلات"]},
  {:name => "هرمزگان"            , :eng_name => "Hormozgan",                  :capital => "بندرعباس",:eng_capital => "Bandar Abbas",:counties => ["ابوموسی", "بستک", "بندر عباس", "بندر لنگه", "پارسیان", "جاسک", "حاجی‌آباد", "خمیر", "رودان", "قشم", "میناب"]},
  {:name => "همدان"              , :eng_name => "Hamadan",                    :capital => "همدان",   :eng_capital => "Hamadan",     :counties => ["اسدآباد", "بهار", "تویسرکان", "رزن", "فامنین", "کبودرآهنگ", "ملایر", "نهاوند", "همدان"]},
  {:name => "یزد"                , :eng_name => "Yazd",                       :capital => "یزد",     :eng_capital => "Yazd",        :counties => ["ابرکوه", "اردکان", "بافق", "بهاباد", "تفت", "خاتم", "صدوق", "طبس", "مهریز", "میبد", "یزد"]},
  ]

  Countries = [
      { :iso2 => 'AC', :fa => 'جزایر آسنسیون', :en => 'Ascension Island' },
      { :iso2 => 'AD', :fa => 'آندورا', :en => 'Andorra' },
      { :iso2 => 'AE', :fa => 'امارات متحدهٔ عربی', :en => 'United Arab Emirates' },
      { :iso2 => 'AF', :fa => 'افغانستان', :en => 'Afghanistan' },
      { :iso2 => 'AG', :fa => 'آنتيگوآ و باربودا', :en => 'Antigua and Barbuda' },
      { :iso2 => 'AI', :fa => 'آنگیل', :en => 'Anguilla' },
      { :iso2 => 'AL', :fa => 'آلبانی', :en => 'Albania' },
      { :iso2 => 'AM', :fa => 'ارمنستان', :en => 'Armenia' },
      { :iso2 => 'AN', :fa => 'آنتیل هلند', :en => 'Netherlands Antilles' },
      { :iso2 => 'AO', :fa => 'آنگولا', :en => 'Angola' },
      { :iso2 => 'AQ', :fa => 'قطب جنوب', :en => 'Antarctica' },
      { :iso2 => 'AR', :fa => 'آرژانتین', :en => 'Argentina' },
      { :iso2 => 'AS', :fa => 'ساموای امریکا', :en => 'American Samoa' },
      { :iso2 => 'AT', :fa => 'اتریش', :en => 'Austria' },
      { :iso2 => 'AU', :fa => 'استرالیا', :en => 'Australia' },
      { :iso2 => 'AW', :fa => 'آروبا', :en => 'Aruba' },
      { :iso2 => 'AX', :fa => 'جزایر آلاند', :en => 'Åland Islands' },
      { :iso2 => 'AZ', :fa => 'جمهوری آذربایجان', :en => 'Azerbaijan' },
      { :iso2 => 'BA', :fa => 'بوسنی و هرزگوین', :en => 'Bosnia and Herzegovina' },
      { :iso2 => 'BB', :fa => 'باربادوس', :en => 'Barbados' },
      { :iso2 => 'BD', :fa => 'بنگلادش', :en => 'Bangladesh' },
      { :iso2 => 'BE', :fa => 'بلژیک', :en => 'Belgium' },
      { :iso2 => 'BF', :fa => 'بورکینافاسو', :en => 'Burkina Faso' },
      { :iso2 => 'BG', :fa => 'بلغارستان', :en => 'Bulgaria' },
      { :iso2 => 'BH', :fa => 'بحرین', :en => 'Bahrain' },
      { :iso2 => 'BI', :fa => 'بروندی', :en => 'Burundi' },
      { :iso2 => 'BJ', :fa => 'بنین', :en => 'Benin' },
      { :iso2 => 'BL', :fa => 'سنت بارتلیمی', :en => 'Saint Barthélemy' },
      { :iso2 => 'BM', :fa => 'برمودا', :en => 'Bermuda' },
      { :iso2 => 'BN', :fa => 'برونئی', :en => 'Brunei' },
      { :iso2 => 'BO', :fa => 'بولیوی', :en => 'Bolivia' },
      { :iso2 => 'BR', :fa => 'برزیل', :en => 'Brazil' },
      { :iso2 => 'BS', :fa => 'باهاما', :en => 'Bahamas' },
      { :iso2 => 'BT', :fa => 'بوتان', :en => 'Bhutan' },
      { :iso2 => 'BV', :fa => 'جزیره بووت', :en => 'Bouvet Island' },
      { :iso2 => 'BW', :fa => 'بوتسوانا', :en => 'Botswana' },
      { :iso2 => 'BY', :fa => 'بیلوروسی', :en => 'Belarus' },
      { :iso2 => 'BZ', :fa => 'بلیز', :en => 'Belize' },
      { :iso2 => 'CA', :fa => 'کانادا', :en => 'Canada' },
      { :iso2 => 'CC', :fa => 'جزایر کوکوس', :en => 'Cocos [Keeling] Islands' },
      { :iso2 => 'CD', :fa => 'کنگو - جمهوری دموکراتیک', :en => 'Congo [DRC]' },
      { :iso2 => 'CF', :fa => 'جمهوری افریقای مرکزی', :en => 'Central African Republic' },
      { :iso2 => 'CG', :fa => 'CG', :en => 'Congo [Republic]' },
      { :iso2 => 'CH', :fa => 'سوئیس', :en => 'Switzerland' },
      { :iso2 => 'CI', :fa => 'ساحل عاج', :en => 'Ivory Coast' },
      { :iso2 => 'CK', :fa => 'جزایر کوک', :en => 'Cook Islands' },
      { :iso2 => 'CL', :fa => 'شیلی', :en => 'Chile' },
      { :iso2 => 'CM', :fa => 'کامرون', :en => 'Cameroon' },
      { :iso2 => 'CN', :fa => 'چین', :en => 'China' },
      { :iso2 => 'CO', :fa => 'کلمبیا', :en => 'Colombia' },
      { :iso2 => 'CP', :fa => 'جزایر کلیپرتون', :en => 'Clipperton Island' },
      { :iso2 => 'CR', :fa => 'کاستاریکا', :en => 'Costa Rica' },
      { :iso2 => 'CS', :fa => 'صربستان و مونته‌نگرو', :en => 'Serbia and Montenegro' },
      { :iso2 => 'CU', :fa => 'کوبا', :en => 'Cuba' },
      { :iso2 => 'CV', :fa => 'کیپ ورد', :en => 'Cape Verde' },
      { :iso2 => 'CX', :fa => 'جزیرهٔ کریسمس', :en => 'Christmas Island' },
      { :iso2 => 'CY', :fa => 'قبرس', :en => 'Cyprus' },
      { :iso2 => 'CZ', :fa => 'جمهوری چک', :en => 'Czech Republic' },
      { :iso2 => 'DE', :fa => 'آلمان', :en => 'Germany' },
      { :iso2 => 'DG', :fa => 'دیه گو گارسیا', :en => 'Diego Garcia' },
      { :iso2 => 'DJ', :fa => 'جیبوتی',                         :en => 'Djibouti' },
      { :iso2 => 'DK', :fa => 'دانمارک',                        :en => 'Denmark' },
      { :iso2 => 'DM', :fa => 'دومینیک',                        :en => 'Dominica' },
      { :iso2 => 'DO', :fa => 'جمهوری دومینیکن',                :en => 'Dominican Republic' },
      { :iso2 => 'DZ', :fa => 'الجزایر',                        :en => 'Algeria' },
      { :iso2 => 'EA', :fa => 'کوتا و میللا',                   :en => 'Ceuta and Melilla' },
      { :iso2 => 'EC', :fa => 'اكوادور',                        :en => 'Ecuador' },
      { :iso2 => 'EE', :fa => 'استونی',                         :en => 'Estonia' },
      { :iso2 => 'EG', :fa => 'مصر',                            :en => 'Egypt' },
      { :iso2 => 'EH', :fa => 'صحرای غربی',                     :en => 'Western Sahara' },
      { :iso2 => 'ER', :fa => 'اریتره',                         :en => 'Eritrea' },
      { :iso2 => 'ES', :fa => 'اسپانیا',                        :en => 'Spain' },
      { :iso2 => 'ET', :fa => 'اتیوپی',                         :en => 'Ethiopia' },
      { :iso2 => 'EU', :fa => 'EU',                             :en => 'EU' },
      { :iso2 => 'FI', :fa => 'فنلاند',                         :en => 'Finland' },
      { :iso2 => 'FJ', :fa => 'فیجی',                           :en => 'Fiji' },
      { :iso2 => 'FK', :fa => 'جزایر فالکلند -ایسلاس مالویناس', :en => 'Falkland Islands [Islas Malvinas]' },
      { :iso2 => 'FM', :fa => 'میکرونزی',                       :en => 'Micronesia' },
      { :iso2 => 'FO', :fa => 'جزایر فارو',                     :en => 'Faroe Islands' },
      { :iso2 => 'FR', :fa => 'فرانسه',                         :en => 'France' },
      { :iso2 => 'GA', :fa => 'گابون',                          :en => 'Gabon' },
      { :iso2 => 'GB', :fa => 'بریتانیا',                       :en => 'United Kingdom' },
      { :iso2 => 'GD', :fa => 'گرانادا',                        :en => 'Grenada' },
      { :iso2 => 'GE', :fa => 'گرجستان',                        :en => 'Georgia' },
      { :iso2 => 'GF', :fa => 'گویان فرانسه', :en => 'French Guiana' },
      { :iso2 => 'GG', :fa => 'گرنزی', :en => 'Guernsey' },
      { :iso2 => 'GH', :fa => 'غنا', :en => 'Ghana' },
      { :iso2 => 'GI', :fa => 'جبل‌الطارق', :en => 'Gibraltar' },
      { :iso2 => 'GL', :fa => 'گرینلند', :en => 'Greenland' },
      { :iso2 => 'GM', :fa => 'گامبیا', :en => 'Gambia' },
      { :iso2 => 'GN', :fa => 'گینه', :en => 'Guinea' },
      { :iso2 => 'GP', :fa => 'جزیره گوادلوپ', :en => 'Guadeloupe' },
      { :iso2 => 'GQ', :fa => 'گینهٔ استوایی', :en => 'Equatorial Guinea' },
      { :iso2 => 'GR', :fa => 'یونان', :en => 'Greece' },
      { :iso2 => 'GS', :fa => 'جورجیای جنوبی و جزایر ساندویچ جنوبی', :en => 'South Georgia and the South Sandwich Islands' },
      { :iso2 => 'GT', :fa => 'گواتمالا', :en => 'Guatemala' },
      { :iso2 => 'GU', :fa => 'گوام', :en => 'Guam' },
      { :iso2 => 'GW', :fa => 'گینهٔ بیسائو', :en => 'Guinea-Bissau' },
      { :iso2 => 'GY', :fa => 'گویان', :en => 'Guyana' },
      { :iso2 => 'HK', :fa => 'هنگ‌ کنگ', :en => 'Hong Kong' },
      { :iso2 => 'HM', :fa => 'جزیرهٔ هرد و جزایر مک‌دونالد', :en => 'Heard Island and McDonald Islands' },
      { :iso2 => 'HN', :fa => 'هندوراس', :en => 'Honduras' },
      { :iso2 => 'HR', :fa => 'کرواسی', :en => 'Croatia' },
      { :iso2 => 'HT', :fa => 'هاییتی', :en => 'Haiti' },
      { :iso2 => 'HU', :fa => 'مجارستان', :en => 'Hungary' },
      { :iso2 => 'IC', :fa => 'جزایر قناری', :en => 'Canary Islands' },
      { :iso2 => 'ID', :fa => 'اندونزی', :en => 'Indonesia' },
      { :iso2 => 'IE', :fa => 'ایرلند', :en => 'Ireland' },
      { :iso2 => 'IL', :fa => 'اسرائیل', :en => 'Israel' },
      { :iso2 => 'IM', :fa => 'جزیرهٔ مان', :en => 'Isle of Man' },
      { :iso2 => 'IN', :fa => 'هند', :en => 'India' },
      { :iso2 => 'IO', :fa => 'مستعمره‌های بریتانیا در اقیانوس هند', :en => 'British Indian Ocean Territory' },
      { :iso2 => 'IQ', :fa => 'عراق', :en => 'Iraq' },
      { :iso2 => 'IR', :fa => 'ایران', :en => 'Iran' },
      { :iso2 => 'IS', :fa => 'ایسلند', :en => 'Iceland' },
      { :iso2 => 'IT', :fa => 'ایتالیا', :en => 'Italy' },
      { :iso2 => 'JE', :fa => 'جرسی', :en => 'Jersey' },
      { :iso2 => 'JM', :fa => 'جامائیکا', :en => 'Jamaica' },
      { :iso2 => 'JO', :fa => 'اردن', :en => 'Jordan' },
      { :iso2 => 'JP', :fa => 'ژاپن', :en => 'Japan' },
      { :iso2 => 'KE', :fa => 'کنیا', :en => 'Kenya' },
      { :iso2 => 'KG', :fa => 'قرقیزستان', :en => 'Kyrgyzstan' },
      { :iso2 => 'KH', :fa => 'کامبوج', :en => 'Cambodia' },
      { :iso2 => 'KI', :fa => 'کریباتی', :en => 'Kiribati' },
      { :iso2 => 'KM', :fa => 'کومورو', :en => 'Comoros' },
      { :iso2 => 'KN', :fa => 'سنت کیتس و نویس', :en => 'Saint Kitts and Nevis' },
      { :iso2 => 'KP', :fa => 'کره شمالی', :en => 'North Korea' },
      { :iso2 => 'KR', :fa => 'کرهٔ جنوبی', :en => 'South Korea' },
      { :iso2 => 'KW', :fa => 'کویت', :en => 'Kuwait' },
      { :iso2 => 'KY', :fa => 'جزایر کِیمن', :en => 'Cayman Islands' },
      { :iso2 => 'KZ', :fa => 'قزاقستان', :en => 'Kazakhstan' },
      { :iso2 => 'LA', :fa => 'لائوس', :en => 'Laos' },
      { :iso2 => 'LB', :fa => 'لبنان', :en => 'Lebanon' },
      { :iso2 => 'LC', :fa => 'سنت لوسیا', :en => 'Saint Lucia' },
      { :iso2 => 'LI', :fa => 'لیختن‌اشتاین', :en => 'Liechtenstein' },
      { :iso2 => 'LK', :fa => 'سريلانكا', :en => 'Sri Lanka' },
      { :iso2 => 'LR', :fa => 'لیبریا', :en => 'Liberia' },
      { :iso2 => 'LS', :fa => 'لسوتو', :en => 'Lesotho' },
      { :iso2 => 'LT', :fa => 'لیتوانی', :en => 'Lithuania' },
      { :iso2 => 'LU', :fa => 'لوکزامبورگ', :en => 'Luxembourg' },
      { :iso2 => 'LV', :fa => 'لتونی', :en => 'Latvia' },
      { :iso2 => 'LY', :fa => 'لیبی', :en => 'Libya' },
      { :iso2 => 'MA', :fa => 'مراکش', :en => 'Morocco' },
      { :iso2 => 'MC', :fa => 'موناکو', :en => 'Monaco' },
      { :iso2 => 'MD', :fa => 'مولداوی', :en => 'Moldova' },
      { :iso2 => 'ME', :fa => 'مونته‌نگرو', :en => 'Montenegro' },
      { :iso2 => 'MF', :fa => 'سنت مارتین', :en => 'Saint Martin' },
      { :iso2 => 'MG', :fa => 'ماداگاسکار', :en => 'Madagascar' },
      { :iso2 => 'MH', :fa => 'جزایر مارشال', :en => 'Marshall Islands' },
      { :iso2 => 'MK', :fa => 'مقدونیه- فایروم', :en => 'Macedonia [FYROM]' },
      { :iso2 => 'ML', :fa => 'مالی', :en => 'Mali' },
      { :iso2 => 'MM', :fa => 'میانمار', :en => 'Myanmar [Burma]' },
      { :iso2 => 'MN', :fa => 'مغولستان', :en => 'Mongolia' },
      { :iso2 => 'MO', :fa => 'ماکائو', :en => 'Macau' },
      { :iso2 => 'MP', :fa => 'جزایر ماریانای شمالی', :en => 'Northern Mariana Islands' },
      { :iso2 => 'MQ', :fa => 'مارتینیک', :en => 'Martinique' },
      { :iso2 => 'MR', :fa => 'موریتانی', :en => 'Mauritania' },
      { :iso2 => 'MS', :fa => 'مونت‌سرات', :en => 'Montserrat' },
      { :iso2 => 'MT', :fa => 'مالت', :en => 'Malta' },
      { :iso2 => 'MU', :fa => 'موریس', :en => 'Mauritius' },
      { :iso2 => 'MV', :fa => 'مالدیو', :en => 'Maldives' },
      { :iso2 => 'MW', :fa => 'مالاوی', :en => 'Malawi' },
      { :iso2 => 'MX', :fa => 'مکزیک', :en => 'Mexico' },
      { :iso2 => 'MY', :fa => 'مالزی', :en => 'Malaysia' },
      { :iso2 => 'MZ', :fa => 'موزامبیک', :en => 'Mozambique' },
      { :iso2 => 'NA', :fa => 'نامیبیا', :en => 'Namibia' },
      { :iso2 => 'NC', :fa => 'کالدونیای جدید', :en => 'New Caledonia' },
      { :iso2 => 'NE', :fa => 'نیجر', :en => 'Niger' },
      { :iso2 => 'NF', :fa => 'جزیرهٔ نورفولک', :en => 'Norfolk Island' },
      { :iso2 => 'NG', :fa => 'نیجریه', :en => 'Nigeria' },
      { :iso2 => 'NI', :fa => 'نیکاراگوئه', :en => 'Nicaragua' },
      { :iso2 => 'NL', :fa => 'هلند', :en => 'Netherlands' },
      { :iso2 => 'NO', :fa => 'نروژ', :en => 'Norway' },
      { :iso2 => 'NP', :fa => 'نپال', :en => 'Nepal' },
      { :iso2 => 'NR', :fa => 'نائورو', :en => 'Nauru' },
      { :iso2 => 'NU', :fa => 'نیوئه', :en => 'Niue' },
      { :iso2 => 'NZ', :fa => 'زلاند نو', :en => 'New Zealand' },
      { :iso2 => 'OM', :fa => 'عمان', :en => 'Oman' },
      { :iso2 => 'PA', :fa => 'پاناما', :en => 'Panama' },
      { :iso2 => 'PE', :fa => 'پرو', :en => 'Peru' },
      { :iso2 => 'PF', :fa => 'پلی‌نزی فرانسه', :en => 'French Polynesia' },
      { :iso2 => 'PG', :fa => 'پاپوا گینه نو', :en => 'Papua New Guinea' },
      { :iso2 => 'PH', :fa => 'فیلیپین', :en => 'Philippines' },
      { :iso2 => 'PK', :fa => 'پاكستان', :en => 'Pakistan' },
      { :iso2 => 'PL', :fa => 'لهستان', :en => 'Poland' },
      { :iso2 => 'PM', :fa => 'سنت پیر و میکلون', :en => 'Saint Pierre and Miquelon' },
      { :iso2 => 'PN', :fa => 'پیتکایرن', :en => 'Pitcairn Islands' },
      { :iso2 => 'PR', :fa => 'پورتو ریکو', :en => 'Puerto Rico' },
      { :iso2 => 'PS', :fa => 'فلسطین', :en => 'Palestinian Territories' },
      { :iso2 => 'PT', :fa => 'پرتغال', :en => 'Portugal' },
      { :iso2 => 'PW', :fa => 'پالائو', :en => 'Palau' },
      { :iso2 => 'PY', :fa => 'پاراگوئه', :en => 'Paraguay' },
      { :iso2 => 'QA', :fa => 'قطر', :en => 'Qatar' },
      { :iso2 => 'QO', :fa => 'بخش‌های دورافتادهٔ اقیانوسیه', :en => 'Outlying Oceania' },
      { :iso2 => 'QU', :fa => 'اتحادیهٔ اروپا', :en => 'European Union' },
      { :iso2 => 'RE', :fa => 'ریونیون', :en => 'Réunion' },
      { :iso2 => 'RO', :fa => 'رومانی', :en => 'Romania' },
      { :iso2 => 'RS', :fa => 'صربستان', :en => 'Serbia' },
      { :iso2 => 'RU', :fa => 'روسیه', :en => 'Russia' },
      { :iso2 => 'RW', :fa => 'رواندا', :en => 'Rwanda' },
      { :iso2 => 'SA', :fa => 'عربستان', :en => 'Saudi Arabia' },
      { :iso2 => 'SB', :fa => 'جزایر سلیمان', :en => 'Solomon Islands' },
      { :iso2 => 'SC', :fa => 'سیشل', :en => 'Seychelles' },
      { :iso2 => 'SD', :fa => 'سودان', :en => 'Sudan' },
      { :iso2 => 'SE', :fa => 'سوئد', :en => 'Sweden' },
      { :iso2 => 'SG', :fa => 'سنگاپور', :en => 'Singapore' },
      { :iso2 => 'SH', :fa => 'سنت هلن', :en => 'Saint Helena' },
      { :iso2 => 'SI', :fa => 'اسلوونی', :en => 'Slovenia' },
      { :iso2 => 'SJ', :fa => 'جزیره های اسوالبارد و جان ماین', :en => 'Svalbard and Jan Mayen' },
      { :iso2 => 'SK', :fa => 'اسلواکی', :en => 'Slovakia' },
      { :iso2 => 'SL', :fa => 'سیرالئون', :en => 'Sierra Leone' },
      { :iso2 => 'SM', :fa => 'سان مارینو', :en => 'San Marino' },
      { :iso2 => 'SN', :fa => 'سنگال', :en => 'Senegal' },
      { :iso2 => 'SO', :fa => 'سومالی', :en => 'Somalia' },
      { :iso2 => 'SR', :fa => 'سورينام', :en => 'Suriname' },
      { :iso2 => 'ST', :fa => 'سائو تومه و پرینسیپه', :en => 'São Tomé and Príncipe' },
      { :iso2 => 'SV', :fa => 'السالوادور', :en => 'El Salvador' },
      { :iso2 => 'SY', :fa => 'سوریه', :en => 'Syria' },
      { :iso2 => 'SZ', :fa => 'سوازیلند', :en => 'Swaziland' },
      { :iso2 => 'TA', :fa => 'تریستان دا سونا', :en => 'Tristan da Cunha' },
      { :iso2 => 'TC', :fa => 'جزایر ترک و کایکوس', :en => 'Turks and Caicos Islands' },
      { :iso2 => 'TD', :fa => 'چاد', :en => 'Chad' },
      { :iso2 => 'TF', :fa => 'مستعمره‌های جنوبی فرانسه', :en => 'French Southern Territories' },
      { :iso2 => 'TG', :fa => 'توگو', :en => 'Togo' },
      { :iso2 => 'TH', :fa => 'تایلند', :en => 'Thailand' },
      { :iso2 => 'TJ', :fa => 'تاجیکستان', :en => 'Tajikistan' },
      { :iso2 => 'TK', :fa => 'توکلائو', :en => 'Tokelau' },
      { :iso2 => 'TL', :fa => 'تیمور شرقی', :en => 'East Timor' },
      { :iso2 => 'TM', :fa => 'ترکمنستان', :en => 'Turkmenistan' },
      { :iso2 => 'TN', :fa => 'تونس', :en => 'Tunisia' },
      { :iso2 => 'TO', :fa => 'تونگا', :en => 'Tonga' },
      { :iso2 => 'TR', :fa => 'ترکیه', :en => 'Turkey' },
      { :iso2 => 'TT', :fa => 'ترینیداد و توباگو', :en => 'Trinidad and Tobago' },
      { :iso2 => 'TV', :fa => 'تووالو', :en => 'Tuvalu' },
      { :iso2 => 'TW', :fa => 'تایوان', :en => 'Taiwan' },
      { :iso2 => 'TZ', :fa => 'تانزانیا', :en => 'Tanzania' },
      { :iso2 => 'UA', :fa => 'اوکراین', :en => 'Ukraine' },
      { :iso2 => 'UG', :fa => 'اوگاندا', :en => 'Uganda' },
      { :iso2 => 'UM', :fa => 'جزایر کوچک دورافتادهٔ ایالات متحده', :en => 'U.S. Minor Outlying Islands' },
      { :iso2 => 'US', :fa => 'ایالات متحدهٔ امریکا', :en => 'United States' },
      { :iso2 => 'UY', :fa => 'اروگوئه', :en => 'Uruguay' },
      { :iso2 => 'UZ', :fa => 'ازبکستان', :en => 'Uzbekistan' },
      { :iso2 => 'VA', :fa => 'واتیکان', :en => 'Vatican City' },
      { :iso2 => 'VC', :fa => 'سنت وینسنت و گرنادین', :en => 'Saint Vincent and the Grenadines' },
      { :iso2 => 'VE', :fa => 'ونزوئلا', :en => 'Venezuela' },
      { :iso2 => 'VG', :fa => 'جزایر ویرجین بریتانیا', :en => 'British Virgin Islands' },
      { :iso2 => 'VI', :fa => 'جزایر ویرجین ایالات متحده', :en => 'U.S. Virgin Islands' },
      { :iso2 => 'VN', :fa => 'ویتنام', :en => 'Vietnam' },
      { :iso2 => 'VU', :fa => 'وانواتو', :en => 'Vanuatu' },
      { :iso2 => 'WF', :fa => 'والیس و فیوتونا', :en => 'Wallis and Futuna' },
      { :iso2 => 'WS', :fa => 'ساموا', :en => 'Samoa' },
      { :iso2 => 'YE', :fa => 'یمن', :en => 'Yemen' },
      { :iso2 => 'YT', :fa => 'مایوت', :en => 'Mayotte' },
      { :iso2 => 'ZA', :fa => 'افریقای جنوبی', :en => 'South Africa' },
      { :iso2 => 'ZM', :fa => 'زامبیا', :en => 'Zambia' },
      { :iso2 => 'ZW', :fa => 'زیمبابوه', :en => 'Zimbabwe' },
      { :iso2 => 'ZZ', :fa => 'ناحیهٔ نامشخص یا نامعتبر', :en => 'Unknown or Invalid Region' }

  ]
  # :startdoc:
end

String.send(:include, FarsiFu::NumbersExtensions::InstanceMethods)
Integer.send(:include, FarsiFu::NumbersExtensions::InstanceMethods)
Numeric.send(:include, FarsiFu::NumbersExtensions::InstanceMethods)
Fixnum.send(:include, FarsiFu::NumbersExtensions::InstanceMethods)
Float.send(:include, FarsiFu::NumbersExtensions::InstanceMethods)