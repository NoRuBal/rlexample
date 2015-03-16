utf8 = require("utf8")

hangul = {}

hangul.basecode = 44032
hangul.chosung = 588
hangul.jungsung = 28
hangul.cho = {"ㄱ", "ㄲ", "ㄴ", "ㄷ", "ㄸ", "ㄹ", "ㅁ", "ㅂ", "ㅃ", "ㅅ", "ㅆ", "ㅇ" , "ㅈ", "ㅉ", "ㅊ", "ㅋ", "ㅌ", "ㅍ", "ㅎ"}
hangul.jung = {"ㅏ", "ㅐ", "ㅑ", "ㅒ", "ㅓ", "ㅔ", "ㅕ", "ㅖ", "ㅗ", "ㅘ", "ㅙ", "ㅚ", "ㅛ", "ㅜ", "ㅝ", "ㅞ", "ㅟ", "ㅠ", "ㅡ", "ㅢ", "ㅣ"}
hangul.jong = {" ", "ㄱ", "ㄲ", "ㄳ", "ㄴ", "ㄵ", "ㄶ", "ㄷ", "ㄹ", "ㄺ", "ㄻ", "ㄼ", "ㄽ", "ㄾ", "ㄿ", "ㅀ", "ㅁ", "ㅂ", "ㅄ", "ㅅ", "ㅆ", "ㅇ", "ㅈ", "ㅊ","ㅋ", "ㅌ", "ㅍ", "ㅎ"}


function hangul.len(hanstring)
	return utf8.len(hanstring)
end

function hangul.getJosa(hanname, josatype)
	--get last letter of hanname
	local splittedletter = hangul.splitchar(hangul.sub(hanname, hangul.len(hanname),  hangul.len(hanname)))
	local jong = splittedletter.jong
	if josatype == "unnun" then
		if jong == 1 then
			return "는"
		else
			return "은"
		end
	elseif josatype == "urrur" then
		if jong == 1 then
			return "를"
		else
			return "을"
		end
	end
end

function hangul.splitchar(hanchar)
	local cho, jung, jong
	hanchar = utf8.codepoint(hanchar)
	hanchar = hanchar - hangul.basecode
	
	--초성
	cho = math.floor(hanchar / hangul.chosung)
	
	--중성
	jung =  math.floor((hanchar - (hangul.chosung * cho)) / hangul.jungsung)
	
	--종성
	jong = (hanchar - (hangul.chosung * cho) - (hangul.jungsung * jung))
	
	cho = cho + 1
	jung = jung + 1
	jong = jong + 1
	
	local tmptable = {}
	tmptable.cho = cho
	tmptable.jung = jung
	tmptable.jong = jong
	return tmptable
end

function utf8charbytes(s, i)
	-- argument defaults
	i = i or 1
	local c = string.byte(s, i)

	-- determine bytes needed for character, based on RFC 3629
	-- validate byte 1
	if c > 0 and c <= 127 then
		-- UTF8-1
		return 1

	elseif c >= 194 and c <= 223 then
		-- UTF8-2
		local c2 = string.byte(s, i + 1)
		return 2

	elseif c >= 224 and c <= 239 then
		-- UTF8-3
		local c2 = string.byte(s, i + 1)
		local c3 = string.byte(s, i + 2)
		
		return 3

	elseif c >= 240 and c <= 244 then
		-- UTF8-4
		local c2 = string.byte(s, i + 1)
		local c3 = string.byte(s, i + 2)
		local c4 = string.byte(s, i + 3)

		return 4

	end
end

function utf8len(s)
	local pos = 1
	local bytes = s:len()
	local len = 0

	while pos <= bytes do
		len = len + 1
		pos = pos + utf8charbytes(s, pos)
	end

	return len
end

function chsize(char)
    if not char then
        return 0
    elseif char > 240 then
        return 4
    elseif char > 225 then
        return 3
    elseif char > 192 then
        return 2
    else
        return 1
    end
end

function hangul.sub(str, startChar, numChars)
  local startIndex = 1
  while startChar > 1 do
      local char = string.byte(str, startIndex)
      startIndex = startIndex + chsize(char)
      startChar = startChar - 1
  end
 
  local currentIndex = startIndex
 
  while numChars > 0 and currentIndex <= #str do
    local char = string.byte(str, currentIndex)
    currentIndex = currentIndex + chsize(char)
    numChars = numChars -1
  end
  return str:sub(startIndex, currentIndex - 1)
end

--사용법:
--require "hangul"
--local splitedhangul = hangul.splitchar("각")
--splitedhangul.cho -> ㄱ
--splitedhangul.jung -> ㅏ
--splitedhangul.jong -> ㄱ