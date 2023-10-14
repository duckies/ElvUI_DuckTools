local D, F, E          = unpack(ElvUI_DuckTools)
local ECH              = E:GetModule("Chat")
local CT               = D:GetModule("D_ChatText")

local format           = format
local gsub             = gsub
local gmatch           = gmatch
local sort             = sort
local strfind          = strfind
local strsub           = strsub
local tinsert          = tinsert
local tremove          = tremove
local unpack           = unpack
local GMChatFrame_IsGM = GMChatFrame_IsGM

CT.cache               = {}
local initRecord       = {}

local specialChatIcons
do --this can save some main file locals
  local x, y          = ':16:16', ':13:25'

  local ElvBlue       = E:TextureString(E.Media.ChatLogos.ElvBlue, y)
  local ElvGreen      = E:TextureString(E.Media.ChatLogos.ElvGreen, y)
  local ElvOrange     = E:TextureString(E.Media.ChatLogos.ElvOrange, y)
  local ElvPurple     = E:TextureString(E.Media.ChatLogos.ElvPurple, y)
  local ElvRed        = E:TextureString(E.Media.ChatLogos.ElvRed, y)
  local ElvYellow     = E:TextureString(E.Media.ChatLogos.ElvYellow, y)
  local ElvSimpy      = E:TextureString(E.Media.ChatLogos.ElvSimpy, y)

  local Bathrobe      = E:TextureString(E.Media.ChatLogos.Bathrobe, x)
  local Rainbow       = E:TextureString(E.Media.ChatLogos.Rainbow, x)
  local Hibiscus      = E:TextureString(E.Media.ChatLogos.Hibiscus, x)
  local Gem           = E:TextureString(E.Media.ChatLogos.Gem, x)
  local Beer          = E:TextureString(E.Media.ChatLogos.Beer, x)
  local PalmTree      = E:TextureString(E.Media.ChatLogos.PalmTree, x)
  local TyroneBiggums = E:TextureString(E.Media.ChatLogos.TyroneBiggums, x)
  local SuperBear     = E:TextureString(E.Media.ChatLogos.SuperBear, x)

  --[[ Simpys Thing: new icon color every message, in order then reversed back, repeating of course
		local a, b, c = 0, false, {ElvRed, ElvOrange, ElvYellow, ElvGreen, ElvBlue, ElvPurple, ElvPink}
		(a = a - (b and 1 or -1) if (b and a == 1 or a == 0) or a == #c then b = not b end return c[a])
	]]
  local itsElv, itsMis, itsSimpy, itsMel, itsThradex, itsPooc
  do --Simpy Chaos: super cute text coloring function that ignores hyperlinks and keywords
    local e, f, g = { '||', '|Helvmoji:.-|h.-|h', '|[Cc].-|[Rr]', '|[TA].-|[ta]', '|H.-|h.-|h' }, {}, {}
    local prettify = function(t, ...)
      return gsub(
        gsub(E:TextGradient(gsub(gsub(t, '%%%%', '\27'), '\124\124', '\26'), ...), '\27', '%%%%'), '\26', '||')
    end
    local protectText = function(t, u, v)
      local w = E:EscapeString(v)
      local r, s = strfind(u, w)
      while f[r] do r, s = strfind(u, w, s) end
      if r then
        tinsert(g, r)
        f[r] = w
      end
      return gsub(t, w, '\24')
    end
    local specialText = function(t, ...)
      local u = t
      for _, w in ipairs(e) do for k in gmatch(t, w) do t = protectText(t, u, k) end end
      t = prettify(t, ...)
      if next(g) then
        if #g > 1 then sort(g) end
        for n in gmatch(t, '\24') do
          local _, v = next(g)
          t = gsub(t, n, f[v], 1)
          tremove(g, 1)
          f[v] = nil
        end
      end
      return t
    end

    --Simpys: Spring Green (2EFF7E), Vivid Sky Blue (52D9FF), Medium Purple (8D63DB), Ticke Me Pink (FF8EB6), Yellow Orange (FFAF53)
    local SimpyColors = function(t)
      return specialText(t, 0.18, 1.00, 0.49, 0.32, 0.85, 1.00, 0.55, 0.38, 0.85, 1.00,
        0.55, 0.71, 1.00, 0.68, 0.32)
    end
    --Detroit Lions: Honolulu Blue to Silver [Elv: I stoles it @Simpy]
    local ElvColors = function(t) return specialText(t, 0, 0.42, 0.69, 0.61, 0.61, 0.61) end
    --Rainbow: FD3E44, FE9849, FFDE4B, 6DFD65, 54C4FC, A35DFA, C679FB, FE81C1
    local MisColors = function(t)
      return specialText(t, 0.99, 0.24, 0.26, 0.99, 0.59, 0.28, 1, 0.87, 0.29, 0.42, 0.99,
        0.39, 0.32, 0.76, 0.98, 0.63, 0.36, 0.98, 0.77, 0.47, 0.98, 0.99, 0.5, 0.75)
    end
    --Mels: Fiery Rose (F94F6D), Saffron (F7C621), Emerald (4FC16D), Medium Slate Blue (7C7AF7), Cyan Process (11AFEA)
    local MelColors = function(t)
      return specialText(t, 0.98, 0.31, 0.43, 0.97, 0.78, 0.13, 0.31, 0.76, 0.43, 0.49,
        0.48, 0.97, 0.07, 0.69, 0.92)
    end
    --Thradex: summer without you
    local ThradexColors = function(t)
      return specialText(t, 0.00, 0.60, 0.09, 0.22, 0.65, 0.90, 0.22, 0.65, 0.90,
        1.00, 0.74, 0.27, 1.00, 0.66, 0.00, 1.00, 0.50, 0.20, 0.92, 0.31, 0.23)
    end
    --Repooc: Monk, Demon Hunter, Paladin, Warlock colors
    local PoocsColors = function(t)
      return specialText(t, 0, 1, 0.6, 0.64, 0.19, 0.79, 0.96, 0.55, 0.73, 0.53, 0.53,
        0.93)
    end

    itsSimpy = function() return ElvSimpy, SimpyColors end
    itsElv = function() return ElvBlue, ElvColors end
    itsMel = function() return Hibiscus, MelColors end
    itsMis = function() return Rainbow, MisColors end
    itsThradex = function() return PalmTree, ThradexColors end
    itsPooc = function() return ElvBlue, PoocsColors end
  end

  local z = {}
  specialChatIcons = z

  if E.Retail then
    -- Elv
    z['Rubbewduck-Illidan'] = itsMel
  end
end

function CT:MessageFormatter(frame, info, chatType, chatGroup, chatTarget, channelLength, coloredName, historySavedName,
                             arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14,
                             arg15, arg16, arg17, isHistory, historyTime, historyName, historyBTag)
  print("In Message Formatter")
  local body
  local noBrackets = CT.db.removeBrackets

  if chatType == 'WHISPER_INFORM' and GMChatFrame_IsGM and GMChatFrame_IsGM(arg2) then
    return
  end

  local showLink = 1
  local isMonster = strsub(chatType, 1, 7) == 'MONSTER'
  if isMonster or strsub(chatType, 1, 9) == 'RAID_BOSS' then
    showLink = nil

    -- fix blizzard formatting errors from localization strings
    -- arg1 = gsub(arg1, '%%%d', '%%s') -- replace %1 to %s (russian client specific?) [broken since BFA?]
    arg1 = gsub(arg1, '(%d%%)([^%%%a])', '%1%%%2') -- escape percentages that need it [broken since SL?]
    arg1 = gsub(arg1, '(%d%%)$', '%1%%')         -- escape percentages on the end
  else
    arg1 = gsub(arg1, '%%', '%%%%')              -- escape any % characters, as it may otherwise cause an 'invalid option in format' error
  end

  --Remove groups of many spaces
  arg1 = RemoveExtraSpaces(arg1)

  -- Search for icon links and replace them with texture links.
  arg1 = ECH:ChatFrame_ReplaceIconAndGroupExpressions(arg1, arg17,
    not _G.ChatFrame_CanChatGroupPerformExpressionExpansion(chatGroup)) -- If arg17 is true, don't convert to raid icons

  -- ElvUI: Get class colored name for BattleNet friend
  if chatType == 'BN_WHISPER' or chatType == 'BN_WHISPER_INFORM' then
    coloredName = historySavedName or ECH:GetBNFriendColor(arg2, arg13)
  end

  -- ElvUI: data from populated guid info
  local nameWithRealm, realm
  local data = ECH:GetPlayerInfoByGUID(arg12)
  if data then
    realm = data.realm
    nameWithRealm = data.nameWithRealm
  end

  local playerLink
  local playerLinkDisplayText = coloredName
  local relevantDefaultLanguage = frame.defaultLanguage
  if chatType == 'SAY' or chatType == 'YELL' then
    relevantDefaultLanguage = frame.alternativeDefaultLanguage
  end
  local usingDifferentLanguage = (arg3 ~= '') and (arg3 ~= relevantDefaultLanguage)
  local usingEmote = (chatType == 'EMOTE') or (chatType == 'TEXT_EMOTE')

  if usingDifferentLanguage or not usingEmote then
    playerLinkDisplayText = format(noBrackets and "%s" or "[%s]", CT:HandleName(coloredName))
  end

  local isCommunityType = chatType == 'COMMUNITIES_CHANNEL'
  local playerName, lineID, bnetIDAccount = (nameWithRealm ~= arg2 and nameWithRealm) or arg2, arg11, arg13
  if isCommunityType then
    local isBattleNetCommunity = bnetIDAccount ~= nil and bnetIDAccount ~= 0
    local messageInfo, clubId, streamId = C_Club_GetInfoFromLastCommunityChatLine()

    if messageInfo ~= nil then
      if isBattleNetCommunity then
        playerLink = GetBNPlayerCommunityLink(playerName, playerLinkDisplayText, bnetIDAccount, clubId, streamId,
          messageInfo.messageId.epoch, messageInfo.messageId.position)
      else
        playerLink = GetPlayerCommunityLink(playerName, playerLinkDisplayText, clubId, streamId,
          messageInfo.messageId.epoch, messageInfo.messageId.position)
      end
    else
      playerLink = playerLinkDisplayText
    end
  elseif chatType == 'BN_WHISPER' or chatType == 'BN_WHISPER_INFORM' then
    playerLink = GetBNPlayerLink(playerName, playerLinkDisplayText, bnetIDAccount, lineID, chatGroup, chatTarget)
  else
    playerLink = GetPlayerLink(playerName, playerLinkDisplayText, lineID, chatGroup, chatTarget)
  end

  local message = arg1
  if arg14 then --isMobile
    message = _G.ChatFrame_GetMobileEmbeddedTexture(info.r, info.g, info.b) .. message
  end

  -- Player Flags
  local pflag = GetPFlag(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14, arg15,
    arg16, arg17)
  if not isMonster then
    local chatIcon, pluginChatIcon = specialChatIcons[arg12] or specialChatIcons[playerName],
        ECH:GetPluginIcon(arg12, playerName)
    if type(chatIcon) == 'function' then
      local icon, prettify, var1, var2, var3 = chatIcon()
      if prettify and chatType ~= 'GUILD_ITEM_LOOTED' and not ECH:MessageIsProtected(message) then
        if chatType == 'TEXT_EMOTE' and not usingDifferentLanguage and (showLink and arg2 ~= '') then
          var1, var2, var3 = strmatch(message, '^(.-)(' .. arg2 .. (realm and '%-' .. realm or '') .. ')(.-)$')
        end

        if var2 then
          if var1 ~= '' then var1 = prettify(var1) end
          if var3 ~= '' then var3 = prettify(var3) end

          message = var1 .. var2 .. var3
        else
          message = prettify(message)
        end
      end

      chatIcon = icon or ''
    end

    -- LFG Role Flags
    local lfgRole = (chatType == 'PARTY_LEADER' or chatType == 'PARTY' or chatType == 'RAID' or chatType == 'RAID_LEADER' or chatType == 'INSTANCE_CHAT' or chatType == 'INSTANCE_CHAT_LEADER') and
        lfgRoles[playerName]
    if lfgRole then
      pflag = pflag .. lfgRole
    end
    -- Special Chat Icon
    if chatIcon then
      pflag = pflag .. chatIcon
    end
    -- Plugin Chat Icon
    if pluginChatIcon then
      pflag = pflag .. pluginChatIcon
    end
  end

  if usingDifferentLanguage then
    local languageHeader = '[' .. arg3 .. '] '
    if showLink and arg2 ~= '' then
      body = format(_G['CHAT_' .. chatType .. '_GET'] .. languageHeader .. message, pflag .. playerLink)
    else
      body = format(_G['CHAT_' .. chatType .. '_GET'] .. languageHeader .. message, pflag .. arg2)
    end
  else
    if not showLink or arg2 == '' then
      if chatType == 'TEXT_EMOTE' or chatType == 'GUILD_DEATHS' then
        body = message
      else
        body = format(_G['CHAT_' .. chatType .. '_GET'] .. message, pflag .. arg2, arg2)
      end
    else
      if chatType == 'EMOTE' then
        body = format(_G['CHAT_' .. chatType .. '_GET'] .. message, pflag .. playerLink)
      elseif chatType == 'TEXT_EMOTE' and realm then
        if info.colorNameByClass then
          body = gsub(message, arg2 .. '%-' .. realm,
            pflag .. gsub(playerLink, '(|h|c.-)|r|h$', '%1-' .. realm .. '|r|h'), 1)
        else
          body = gsub(message, arg2 .. '%-' .. realm, pflag .. gsub(playerLink, '(|h.-)|h$', '%1-' ..
            realm .. '|h'), 1)
        end
      elseif chatType == 'TEXT_EMOTE' then
        body = gsub(message, arg2, pflag .. playerLink, 1)
      elseif chatType == 'GUILD_ITEM_LOOTED' then
        body = gsub(message, '$s', pflag .. playerLink, 1)
      else
        body = format(_G['CHAT_' .. chatType .. '_GET'] .. message, pflag .. playerLink)
      end
    end
  end

  -- Add Channel
  if channelLength > 0 then
    body = '|Hchannel:channel:' .. arg8 .. '|h[' .. _G.ChatFrame_ResolvePrefixedChannelName(arg4) .. ']|h ' .. body
  end

  if (chatType ~= 'EMOTE' and chatType ~= 'TEXT_EMOTE') and (CH.db.shortChannels or CH.db.hideChannels) then
    body = ECH:HandleShortChannels(body, CH.db.hideChannels)
  end

  for _, filter in ipairs(CH.PluginMessageFilters) do
    body = filter(body)
  end

  return body
end

function CT:ChatFrame_MessageEventHandler(frame, event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10,
                                          arg11, arg12, arg13, arg14, arg15, arg16, arg17, isHistory, historyTime,
                                          historyName, historyBTag)
  print(event)
  -- ElvUI Chat History Note: isHistory, historyTime, historyName, and historyBTag are passed from CH:DisplayChatHistory() and need to be on the end to prevent issues in other addons that listen on ChatFrame_MessageEventHandler.
  -- we also send isHistory and historyTime into CH:AddMessage so that we don't have to override the timestamp.
  local noBrackets = CT.db.removeBrackets
  local notChatHistory, historySavedName --we need to extend the arguments on CH.ChatFrame_MessageEventHandler so we can properly handle saved names without overriding
  if isHistory == "ElvUI_ChatHistory" then
    if historyBTag then
      arg2 = historyBTag
    end -- swap arg2 (which is a |k string) to btag name
    historySavedName = historyName
  else
    notChatHistory = true
  end

  if _G.TextToSpeechFrame_MessageEventHandler and notChatHistory then
    _G.TextToSpeechFrame_MessageEventHandler(frame, event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10,
      arg11, arg12, arg13, arg14, arg15, arg16, arg17)
  end

  if strsub(event, 1, 8) == "CHAT_MSG" then
    if arg16 then
      return true
    end -- hiding sender in letterbox: do NOT even show in chat window (only shows in cinematic frame)

    local chatType = strsub(event, 10)
    local info = _G.ChatTypeInfo[chatType]

    --If it was a GM whisper, dispatch it to the GMChat addon.
    if arg6 == "GM" and chatType == "WHISPER" then
      return
    end

    local chatFilters = _G.ChatFrame_GetMessageEventFilters(event)
    if chatFilters then
      for _, filterFunc in next, chatFilters do
        local filter, new1, new2, new3, new4, new5, new6, new7, new8, new9, new10, new11, new12, new13, new14, new15, new16, new17 =
            filterFunc(frame, event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13,
              arg14,
              arg15, arg16, arg17)
        if filter then
          return true
        elseif new1 then
          arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14, arg15, arg16, arg17 =
              new1, new2, new3, new4, new5, new6, new7, new8, new9, new10, new11, new12, new13, new14, new15, new16,
              new17
        end
      end
    end

    -- fetch the name color to use
    local coloredName = historySavedName or
        ECH:GetColoredName(event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14)

    local channelLength = strlen(arg4)
    local infoType = chatType

    if chatType == "VOICE_TEXT" then -- the code here looks weird but its how blizzard has it ~Simpy
      local leader = UnitIsGroupLeader(arg2)
      infoType, chatType = _G.VoiceTranscription_DetermineChatTypeVoiceTranscription_DetermineChatType(leader)
      info = _G.ChatTypeInfo[infoType]
    elseif
        chatType == "COMMUNITIES_CHANNEL" or
        ((strsub(chatType, 1, 7) == "CHANNEL") and (chatType ~= "CHANNEL_LIST") and
          ((arg1 ~= "INVITE") or (chatType ~= "CHANNEL_NOTICE_USER")))
    then
      if arg1 == "WRONG_PASSWORD" then
        local _, popup = _G.StaticPopup_Visible("CHAT_CHANNEL_PASSWORD")
        if popup and strupper(popup.data) == strupper(arg9) then
          return -- Don't display invalid password messages if we're going to prompt for a password (bug 102312)
        end
      end

      local found = false
      for index, value in pairs(frame.channelList) do
        if channelLength > strlen(value) then
          -- arg9 is the channel name without the number in front...
          if (arg7 > 0 and frame.zoneChannelList[index] == arg7) or (strupper(value) == strupper(arg9)) then
            found = true

            infoType = "CHANNEL" .. arg8
            info = _G.ChatTypeInfo[infoType]

            if chatType == "CHANNEL_NOTICE" and arg1 == "YOU_LEFT" then
              frame.channelList[index] = nil
              frame.zoneChannelList[index] = nil
            end
            break
          end
        end
      end

      if not found or not info then
        local eventType, channelID = arg1, arg7
        if not ChatFrame_CheckAddChannel(self, eventType, channelID) then
          return true
        end
      end
    end

    local chatGroup = _G.Chat_GetChatCategory(chatType)
    local chatTarget = ECH:FCFManager_GetChatTarget(chatGroup, arg2, arg8)

    if _G.FCFManager_ShouldSuppressMessage(frame, chatGroup, chatTarget) then
      return true
    end

    if chatGroup == "WHISPER" or chatGroup == "BN_WHISPER" then
      if frame.privateMessageList and not frame.privateMessageList[strlower(arg2)] then
        return true
      elseif
          frame.excludePrivateMessageList and frame.excludePrivateMessageList[strlower(arg2)] and
          ((chatGroup == "WHISPER" and GetCVar("whisperMode") ~= "popout_and_inline") or
            (chatGroup == "BN_WHISPER" and GetCVar("whisperMode") ~= "popout_and_inline"))
      then
        return true
      end
    end

    if frame.privateMessageList then
      -- Dedicated BN whisper windows need online/offline messages for only that player
      if
          (chatGroup == "BN_INLINE_TOAST_ALERT" or chatGroup == "BN_WHISPER_PLAYER_OFFLINE") and
          not frame.privateMessageList[strlower(arg2)]
      then
        return true
      end

      -- HACK to put certain system messages into dedicated whisper windows
      if chatGroup == "SYSTEM" then
        local matchFound = false
        local message = strlower(arg1)
        for playerName in pairs(frame.privateMessageList) do
          local playerNotFoundMsg = strlower(format(_G.ERR_CHAT_PLAYER_NOT_FOUND_S, playerName))
          local charOnlineMsg = strlower(format(_G.ERR_FRIEND_ONLINE_SS, playerName, playerName))
          local charOfflineMsg = strlower(format(_G.ERR_FRIEND_OFFLINE_S, playerName))
          if message == playerNotFoundMsg or message == charOnlineMsg or message == charOfflineMsg then
            matchFound = true
            break
          end
        end

        if not matchFound then
          return true
        end
      end
    end

    if
        (chatType == "SYSTEM" or chatType == "SKILL" or chatType == "CURRENCY" or chatType == "MONEY" or
          chatType == "OPENING" or
          chatType == "TRADESKILLS" or
          chatType == "PET_INFO" or
          chatType == "TARGETICONS" or
          chatType == "BN_WHISPER_PLAYER_OFFLINE")
    then
      if chatType ~= "SYSTEM" or not CT:ElvUIChat_GuildMemberStatusMessageHandler(frame, arg1) then
        frame:AddMessage(arg1, info.r, info.g, info.b, info.id, nil, nil, nil, nil, nil, isHistory, historyTime)
      end
    elseif chatType == "LOOT" then
      frame:AddMessage(arg1, info.r, info.g, info.b, info.id, nil, nil, nil, nil, nil, isHistory, historyTime)
    elseif strsub(chatType, 1, 7) == "COMBAT_" then
      frame:AddMessage(arg1, info.r, info.g, info.b, info.id, nil, nil, nil, nil, nil, isHistory, historyTime)
    elseif strsub(chatType, 1, 6) == "SPELL_" then
      frame:AddMessage(arg1, info.r, info.g, info.b, info.id, nil, nil, nil, nil, nil, isHistory, historyTime)
    elseif strsub(chatType, 1, 10) == "BG_SYSTEM_" then
      frame:AddMessage(arg1, info.r, info.g, info.b, info.id, nil, nil, nil, nil, nil, isHistory, historyTime)
    elseif strsub(chatType, 1, 11) == "ACHIEVEMENT" then
      -- Append [Share] hyperlink
      frame:AddMessage(
        format(arg1, GetPlayerLink(arg2, format(noBrackets and "%s" or "[%s]", CT:HandleName(coloredName)))),
        info.r,
        info.g,
        info.b,
        info.id,
        nil,
        nil,
        nil,
        nil,
        nil,
        isHistory,
        historyTime
      )
    elseif strsub(chatType, 1, 18) == "GUILD_ACHIEVEMENT" then
      if not CT:ElvUIChat_AchievementMessageHandler(event, frame, arg1, arg12) then
        local message = format(arg1, GetPlayerLink(arg2, format(noBrackets and "%s" or "[%s]", coloredName)))
        frame:AddMessage(
          message,
          info.r,
          info.g,
          info.b,
          info.id,
          nil,
          nil,
          nil,
          nil,
          nil,
          isHistory,
          historyTime
        )
      end
    elseif chatType == "PING" then
      frame:AddMessage(arg1, info.r, info.g, info.b, info.id, nil, nil, nil, nil, nil, isHistory, historyTime)
    elseif chatType == "IGNORED" then
      frame:AddMessage(
        format(_G.CHAT_IGNORED, arg2),
        info.r,
        info.g,
        info.b,
        info.id,
        nil,
        nil,
        nil,
        nil,
        nil,
        isHistory,
        historyTime
      )
    elseif chatType == "FILTERED" then
      frame:AddMessage(
        format(_G.CHAT_FILTERED, arg2),
        info.r,
        info.g,
        info.b,
        info.id,
        nil,
        nil,
        nil,
        nil,
        nil,
        isHistory,
        historyTime
      )
    elseif chatType == "RESTRICTED" then
      frame:AddMessage(
        _G.CHAT_RESTRICTED_TRIAL,
        info.r,
        info.g,
        info.b,
        info.id,
        nil,
        nil,
        nil,
        nil,
        nil,
        isHistory,
        historyTime
      )
    elseif chatType == "CHANNEL_LIST" then
      if channelLength > 0 then
        frame:AddMessage(
          format(_G["CHAT_" .. chatType .. "_GET"] .. arg1, tonumber(arg8), arg4),
          info.r,
          info.g,
          info.b,
          info.id,
          nil,
          nil,
          nil,
          nil,
          nil,
          isHistory,
          historyTime
        )
      else
        frame:AddMessage(arg1, info.r, info.g, info.b, info.id, nil, nil, nil, nil, nil, isHistory, historyTime)
      end
    elseif chatType == "CHANNEL_NOTICE_USER" then
      local globalstring = _G["CHAT_" .. arg1 .. "_NOTICE_BN"]
      if not globalstring then
        globalstring = _G["CHAT_" .. arg1 .. "_NOTICE"]
      end
      if not globalstring then
        GMError(format("Missing global string for %q", "CHAT_" .. arg1 .. "_NOTICE_BN"))
        return
      end
      if arg5 ~= "" then
        -- TWO users in this notice (E.G. x kicked y)
        frame:AddMessage(
          format(globalstring, arg8, arg4, arg2, arg5),
          info.r,
          info.g,
          info.b,
          info.id,
          nil,
          nil,
          nil,
          nil,
          nil,
          isHistory,
          historyTime
        )
      elseif arg1 == "INVITE" then
        frame:AddMessage(
          format(globalstring, arg4, arg2),
          info.r,
          info.g,
          info.b,
          info.id,
          nil,
          nil,
          nil,
          nil,
          nil,
          isHistory,
          historyTime
        )
      else
        frame:AddMessage(
          format(globalstring, arg8, arg4, arg2),
          info.r,
          info.g,
          info.b,
          info.id,
          nil,
          nil,
          nil,
          nil,
          nil,
          isHistory,
          historyTime
        )
      end
      if arg1 == "INVITE" and GetCVarBool("blockChannelInvites") then
        frame:AddMessage(
          _G.CHAT_MSG_BLOCK_CHAT_CHANNEL_INVITE,
          info.r,
          info.g,
          info.b,
          info.id,
          nil,
          nil,
          nil,
          nil,
          nil,
          isHistory,
          historyTime
        )
      end
    elseif chatType == "CHANNEL_NOTICE" then
      local accessID = _G.ChatHistory_GetAccessID(chatGroup, arg8)
      local typeID = _G.ChatHistory_GetAccessID(infoType, arg8, arg12)

      if E.Retail and arg1 == "YOU_CHANGED" and C_ChatInfo_GetChannelRuleset(arg8) == CHATCHANNELRULESET_MENTOR then
        _G.ChatFrame_UpdateDefaultChatTarget(frame)
        _G.ChatEdit_UpdateNewcomerEditBoxHint(frame.editBox)
      else
        if E.Retail and arg1 == "YOU_LEFT" then
          _G.ChatEdit_UpdateNewcomerEditBoxHint(frame.editBox, arg8)
        end

        local globalstring
        if arg1 == "TRIAL_RESTRICTED" then
          globalstring = _G.CHAT_TRIAL_RESTRICTED_NOTICE_TRIAL
        else
          globalstring = _G["CHAT_" .. arg1 .. "_NOTICE_BN"]
          if not globalstring then
            globalstring = _G["CHAT_" .. arg1 .. "_NOTICE"]
            if not globalstring then
              GMError(format("Missing global string for %q", "CHAT_" .. arg1 .. "_NOTICE"))
              return
            end
          end
        end

        frame:AddMessage(
          format(globalstring, arg8, _G.ChatFrame_ResolvePrefixedChannelName(arg4)),
          info.r,
          info.g,
          info.b,
          info.id,
          accessID,
          typeID,
          nil,
          nil,
          nil,
          isHistory,
          historyTime
        )
      end
    elseif chatType == "BN_INLINE_TOAST_ALERT" then
      local globalstring = _G["BN_INLINE_TOAST_" .. arg1]
      if not globalstring then
        GMError(format("Missing global string for %q", "BN_INLINE_TOAST_" .. arg1))
        return
      end

      local message
      if arg1 == "FRIEND_REQUEST" then
        message = globalstring
      elseif arg1 == "FRIEND_PENDING" then
        message = format(_G.BN_INLINE_TOAST_FRIEND_PENDING, BNGetNumFriendInvites())
      elseif arg1 == "FRIEND_REMOVED" or arg1 == "BATTLETAG_FRIEND_REMOVED" then
        message = format(globalstring, arg2)
      elseif arg1 == "FRIEND_ONLINE" or arg1 == "FRIEND_OFFLINE" then
        local _, _, battleTag, _, characterName, _, clientProgram = CH.BNGetFriendInfoByID(arg13)

        if clientProgram and clientProgram ~= "" then
          C_Texture_GetTitleIconTexture(
            clientProgram,
            TitleIconVersion_Small,
            function(success, texture)
              if success then
                local charName =
                    _G.BNet_GetValidatedCharacterNameWithClientEmbeddedTexture(
                      characterName,
                      battleTag,
                      texture,
                      32,
                      32,
                      10
                    )
                local linkDisplayText = format(noBrackets and "%s (%s)" or "[%s] (%s)", arg2, charName)
                local playerLink = GetBNPlayerLink(arg2, linkDisplayText, arg13, arg11, chatGroup, 0)
                frame:AddMessage(
                  format(globalstring, playerLink),
                  info.r,
                  info.g,
                  info.b,
                  info.id,
                  nil,
                  nil,
                  nil,
                  nil,
                  nil,
                  isHistory,
                  historyTime
                )

                if notChatHistory then
                  FlashTabIfNotShown(frame, info, chatType, chatGroup, chatTarget)
                end
              end
            end
          )

          return
        else
          local linkDisplayText = format(noBrackets and "%s" or "[%s]", arg2)
          local playerLink = GetBNPlayerLink(arg2, linkDisplayText, arg13, arg11, chatGroup, 0)
          message = format(globalstring, playerLink)
        end
      else
        local linkDisplayText = format(noBrackets and "%s" or "[%s]", arg2)
        local playerLink = GetBNPlayerLink(arg2, linkDisplayText, arg13, arg11, chatGroup, 0)
        message = format(globalstring, playerLink)
      end

      frame:AddMessage(message, info.r, info.g, info.b, info.id, nil, nil, isHistory, historyTime)
    elseif chatType == "BN_INLINE_TOAST_BROADCAST" then
      if arg1 ~= "" then
        arg1 = RemoveNewlines(RemoveExtraSpaces(arg1))
        local linkDisplayText = format(noBrackets and "%s" or "[%s]", arg2)
        local playerLink = GetBNPlayerLink(arg2, linkDisplayText, arg13, arg11, chatGroup, 0)
        frame:AddMessage(
          format(_G.BN_INLINE_TOAST_BROADCAST, playerLink, arg1),
          info.r,
          info.g,
          info.b,
          info.id,
          nil,
          nil,
          nil,
          nil,
          nil,
          isHistory,
          historyTime
        )
      end
    elseif chatType == "BN_INLINE_TOAST_BROADCAST_INFORM" then
      if arg1 ~= "" then
        frame:AddMessage(
          _G.BN_INLINE_TOAST_BROADCAST_INFORM,
          info.r,
          info.g,
          info.b,
          info.id,
          nil,
          nil,
          nil,
          nil,
          nil,
          isHistory,
          historyTime
        )
      end
    else
      -- The message formatter is captured so that the original message can be reformatted when a censored message
      -- is approved to be shown. We only need to pack the event args if the line was censored, as the message transformation
      -- step is the only code that needs these arguments. See ItemRef.lua "censoredmessage".
      local isChatLineCensored, eventArgs, msgFormatter =
          C_ChatInfo_IsChatLineCensored and C_ChatInfo_IsChatLineCensored(arg11) -- arg11: lineID
      if isChatLineCensored then
        eventArgs =
            _G.SafePack(
              arg1,
              arg2,
              arg3,
              arg4,
              arg5,
              arg6,
              arg7,
              arg8,
              arg9,
              arg10,
              arg11,
              arg12,
              arg13,
              arg14,
              arg15,
              arg16,
              arg17
            )
        msgFormatter = function(msg) -- to translate the message on click [Show Message]
          local body =
              CT:MessageFormatter(
                frame,
                info,
                chatType,
                chatGroup,
                chatTarget,
                channelLength,
                coloredName,
                historySavedName,
                msg,
                arg2,
                arg3,
                arg4,
                arg5,
                arg6,
                arg7,
                arg8,
                arg9,
                arg10,
                arg11,
                arg12,
                arg13,
                arg14,
                arg15,
                arg16,
                arg17,
                isHistory,
                historyTime,
                historyName,
                historyBTag
              )
          return ECH:AddMessageEdits(frame, body, isHistory, historyTime)
        end
      end

      -- beep boops
      local alertType =
          notChatHistory and not ECH.SoundTimer and not strfind(event, "_INFORM") and
          ECH.db.channelAlerts[historyTypes[event]]
      if
          alertType and alertType ~= "None" and arg2 ~= PLAYER_NAME and
          (not ECH.db.noAlertInCombat or not InCombatLockdown())
      then
        ECH.SoundTimer = E:Delay(5, ECH.ThrottleSound)
        PlaySoundFile(LSM:Fetch("sound", alertType), "Master")
      end

      local accessID = _G.ChatHistory_GetAccessID(chatGroup, chatTarget)
      local typeID = _G.ChatHistory_GetAccessID(infoType, chatTarget, arg12 or arg13)
      local body =
          isChatLineCensored and arg1 or
          CT:MessageFormatter(
            frame,
            info,
            chatType,
            chatGroup,
            chatTarget,
            channelLength,
            coloredName,
            historySavedName,
            arg1,
            arg2,
            arg3,
            arg4,
            arg5,
            arg6,
            arg7,
            arg8,
            arg9,
            arg10,
            arg11,
            arg12,
            arg13,
            arg14,
            arg15,
            arg16,
            arg17,
            isHistory,
            historyTime,
            historyName,
            historyBTag
          )

      frame:AddMessage(
        body,
        info.r,
        info.g,
        info.b,
        info.id,
        accessID,
        typeID,
        event,
        eventArgs,
        msgFormatter,
        isHistory,
        historyTime
      )
    end

    if notChatHistory and (chatType == "WHISPER" or chatType == "BN_WHISPER") then
      _G.ChatEdit_SetLastTellTarget(arg2, chatType)
      if CH.db.flashClientIcon then
        FlashClientIcon()
      end
    end

    if notChatHistory then
      FlashTabIfNotShown(frame, info, chatType, chatGroup, chatTarget)
    end

    return true
  end
end

-- The table referencing the special chat formatting
-- is local to the ElvUI chat module, so we have to
-- override the function that calls it.
function CT:Override_ChatFrame_MessageEventHandler()
  -- self:Log("info", "Overriding ChatFrame_MessageEventHandler")

  ECH.ChatFrame_MessageEventHandler = CT.ChatFrame_MessageEventHandler
  -- if not initRecord.chat_handler then
  -- 	CT.cache.ChatFrame_MessageEventHandler = ECH.ChatFrame_MessageEventHandler
  -- 	ECH.ChatFrame_MessageEventHandler = CT.ChatFrame_MessageEventHandler
  -- 	print('Swappied!')
  -- 	initRecord.chat_handler = true
  -- else
  -- 	if initRecord.chat_handler then
  -- 		if CT.cache.ChatFrame_MessageEventHandler then
  -- 			print("Toggled OFF")
  -- 			ECH.ChatFrame_MessageEventHandler = CT.cache.ChatFrame_MessageEventHandler
  -- 			initRecord.chat_handler = false
  -- 		end
  -- 	end
  -- end
end

function CT:Initialize()
  self:Override_ChatFrame_MessageEventHandler()
end

D:RegisterModule(CT:GetName())
