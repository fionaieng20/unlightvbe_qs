Attribute VB_Name = "執行指令集"
'Public commadstr1()  As String, commadstr2() As String
Public commadstr3() As String '執行指令字串暫時變數
Public vbecommadnum() As Integer '執行階段指令集變數-數值類(執行階段執行中計數值,1.目前執行指令次序/2.目前執行指令分階段/3.目前執行腳本物件號/4.目前之執行階段號)
Public vbecommadstr() As String '執行階段指令集變數-字串類(執行階段執行中計數值,1.目前執行指令名稱/2.目前執行階段指令串)
Public vbecommadtotplay As Integer '目前執行之執行階段計數值
Public Vss_AtkingDrawCardsNum As Integer '執行指令集-技能抽牌牌數紀錄暫時變數
Public Vss_AtkingSeizeEnemyCardsNum As Integer '執行指令集-奪取對手卡牌紀錄暫時變數
Public Vss_AtkingStartPlayNum(1 To 3) As Integer '執行指令集-技能動畫執行紀錄暫時變數
Public Vss_EventBloodActionOffNum As Integer '執行指令集-原應執行之傷害無效化紀錄暫時變數
Public Vss_EventHPLActionOffNum As Integer '執行指令集-原應執行之回復無效化紀錄暫時變數
Public Vss_EventRemoveBuffActionOffNum As Integer '執行指令集-原應執行之異常狀態消除無效化標記暫時變數
Public Vss_EventRemoveActualStatusActionOffNum As Integer '執行指令集-原應執行之人物實際狀態消除無效化標記暫時變數
Public Vss_PersonAtkingOffNum(1 To 2, 1 To 3) As Integer '執行指令集-禁止執行人物主動技及被動技技能紀錄暫時變數(1.使用者/2.電腦,1~3人物編號)
Public Vss_EventActiveAIScoreNum() As Integer '執行指令集-智慧型AI個別技能評分紀錄暫時變數(1.該排列組合技能評分回復/2.評分標準回復/3~.技能推薦之個別期望推薦牌編號)
Public Vss_PersonMoveControlNum(1 To 2, 1 To 2) As Integer  '執行指令集-移動前總移動量控制暫時變數(1.使用者方/2.電腦方,1.移動變化量/2.是否為指定)
Public Vss_AtkingInformationRecordStr(1 To 2, 1 To 3, 1 To 8) As String '執行指令集-技能備註資訊儲存暫時變數(1.使用者/2.電腦,1~3人物編號,技能自行備註字串)
Sub 執行指令集總程序_擷取指令(ByVal str As String, ByVal ns As Integer)
      vbecommadstr(2, vbecommadtotplay) = str
      vbecommadnum(1, vbecommadtotplay) = 1
      vbecommadnum(2, vbecommadtotplay) = 1
      '===============
      commadstr1 = Split(vbecommadstr(2, vbecommadtotplay), "=")
      vbecommadnum(5, vbecommadtotplay) = UBound(commadstr1)
End Sub
Sub 執行指令集總程序_執行階段結束(ByVal ns As Integer)
    vbecommadnum(1, vbecommadtotplay) = 0
    vbecommadnum(2, vbecommadtotplay) = 0
    vbecommadnum(3, vbecommadtotplay) = 0
    vbecommadnum(4, vbecommadtotplay) = 0
    vbecommadstr(1, vbecommadtotplay) = ""
    vbecommadstr(2, vbecommadtotplay) = ""
End Sub
Sub 執行指令集總程序_指令呼叫執行(ByVal uscom As Integer, ByVal commadtype As Integer, ByVal atkingnum As Integer, ByVal ns As Integer)
'======commadtype(1.一般執行階段/2.動畫中效果執行階段)
     If Formsetting.checktest.Value = 0 Then On Error GoTo vss_cmdlocalerr
     Dim cmdnumnow As Integer
     Dim PersonCheckAtking As Boolean
     PersonCheckAtking = 執行指令集_執行驗證(uscom, commadtype, atkingnum)
     Dim commadstr1()  As String, commadstr2() As String
     '===============================
     Do While vbecommadnum(1, vbecommadtotplay) <= vbecommadnum(5, vbecommadtotplay)
        commadstr1 = Split(vbecommadstr(2, vbecommadtotplay), "=")
        commadstr2 = Split(commadstr1(vbecommadnum(1, vbecommadtotplay) - 1), "#")
        vbecommadnum(2, vbecommadtotplay) = 1
        cmdnumnow = vbecommadnum(1, vbecommadtotplay)
        vbecommadstr(1, vbecommadtotplay) = commadstr2(0)
        vbecommadstr(3, vbecommadtotplay) = commadstr2(1)
        '=============================================
        If PersonCheckAtking = False And _
               commadstr2(0) <> "AtkingLineLight" And commadstr2(0) <> "AtkingTurnOnOff" And commadstr2(0) <> "EventActiveAIScore" Then
               執行指令集.執行指令_指令結束標記
        Else
            Do
                Select Case commadstr2(0)
                        Case "AtkingLineLight"
                               執行指令集.執行指令_技能燈控制 uscom, commadtype, atkingnum '(階段1)
                        Case "AtkingTurnOnOff"
                               執行指令集.執行指令_技能啟動碼控制 uscom, commadtype, atkingnum  '(階段1)
                     '=======================================================
                        Case "EventTotalDiceChange"
                               執行指令集.執行指令_總骰數變化量控制 uscom, commadtype, atkingnum  '(階段1)
                        Case "PersonTotalDiceControl"
                               執行指令集.執行指令_總骰數總量控制 uscom, commadtype, atkingnum  '(階段1)
                        Case "PersonBloodControl"
                               執行指令集.執行指令_人物血量控制 uscom, commadtype, atkingnum  '(階段1)
                        Case "PersonAtkingInvalid"
                               執行指令集.執行指令_人物技能無效化 uscom, commadtype, atkingnum  '(階段1)
                        Case "BattleMoveControl"
                               執行指令集.執行指令_場地距離控制 uscom, commadtype, atkingnum  '(階段1)
                        Case "AtkingStartPlay"
                               執行指令集.執行指令_技能動畫執行 uscom, commadtype, atkingnum  '(階段1)
                        Case "AtkingSeizeEnemyCards"
                               執行指令集.執行指令_奪取對手卡牌 uscom, commadtype, atkingnum  '(階段1)
                        Case "AtkingDrawCards"
                               執行指令集.執行指令_技能抽牌 uscom, commadtype, atkingnum  '(階段1)
                        Case "BattleDeckShuffle"
                               執行指令集.執行指令_系統強制洗牌 uscom, commadtype, atkingnum  '(階段1)
                        Case "BattleTurnControl"
                               執行指令集.執行指令_系統回合數控制 uscom, commadtype, atkingnum  '(階段1)
                        Case "AtkingDestroyCards"
                               執行指令集.執行指令_擁有卡牌丟牌 uscom, commadtype, atkingnum  '(階段1)
                        Case "AtkingGiveCards"
                               執行指令集.執行指令_送與卡牌 uscom, commadtype, atkingnum  '(階段1)
                        Case "AtkingGetUsedCards"
                               執行指令集.執行指令_墓地牌回牌 uscom, commadtype, atkingnum  '(階段1)
                        Case "BattleSendMessage"
                               執行指令集.執行指令_傳送訊息 uscom, commadtype, atkingnum  '(階段1)
                        Case "AtkingTrueDiceControl"
                               執行指令集.執行指令_正面骰數控制 uscom, commadtype, atkingnum  '(階段1)
                        Case "AtkingOneSelfCardControl"
                               執行指令集.執行指令_擁有之卡牌控制 uscom, commadtype, atkingnum  '(階段1)
                        Case "BattleStartDice"
                               執行指令集.執行指令_執行擲骰子 uscom, commadtype, atkingnum  '(階段1)
                        Case "PersonMaxCardsNumControl"
                               執行指令集.執行指令_人物最大卡格數控制 uscom, commadtype, atkingnum  '(階段1)
                        Case "BattleInsertEventCard"
                               執行指令集.執行指令_插入事件卡 uscom, commadtype, atkingnum  '(階段1)
                        Case "PersonAddBuff"
                               執行指令集.執行指令_異常狀態控制_加入 uscom, commadtype, atkingnum  '(階段1)
                        Case "PersonRemoveBuffAll"
                               執行指令集.執行指令_異常狀態控制_全部清除_專 uscom, commadtype, atkingnum  '(階段1)
                        Case "PersonRemoveBuffSelect"
                               執行指令集.執行指令_異常狀態控制_特定清除_專 uscom, commadtype, atkingnum  '(階段1)
                        Case "PersonAddActualStatus"
                               執行指令集.執行指令_人物實際狀態控制_加入 uscom, commadtype, atkingnum  '(階段1)
                        Case "PersonRemoveActualStatus"
                               執行指令集.執行指令_人物實際狀態控制_特定解除_專 uscom, commadtype, atkingnum  '(階段1)
                        Case "PersonAtkingOff"
                               執行指令集.執行指令_禁止執行人物主動技及被動技技能 uscom, commadtype, atkingnum  '(階段1)
                        Case "PersonMoveControl"
                               執行指令集.執行指令_移動前總移動量控制 uscom, commadtype, atkingnum  '(階段1)
                        Case "AtkingInformationRecord"
                               執行指令集.執行指令_技能註記備註字串 uscom, commadtype, atkingnum  '(階段1)
                        '========================================================
                        Case "BuffTurnEnd"
                               執行指令集.執行指令_異常狀態控制_當回合結束_專 uscom, commadtype, atkingnum  '(階段1)
                        Case "EventBloodActionOff"
                               執行指令集.執行指令_執行之傷害無效化_專 uscom, commadtype, atkingnum  '(階段1)
                        Case "EventHPLActionOff"
                               執行指令集.執行指令_執行之回復無效化_專 uscom, commadtype, atkingnum  '(階段1)
                        Case "EventRemoveBuffActionOff"
                               執行指令集.執行指令_執行之異常狀態消滅無效化_專 uscom, commadtype, atkingnum  '(階段1)
                        Case "EventAddActualStatusData"
                               執行指令集.執行指令_人物實際狀態加入資料_專 uscom, commadtype, atkingnum  '(階段1)
                        Case "ActualStatusEnd"
                               執行指令集.執行指令_人物實際狀態控制_宣告結束_專 uscom, commadtype, atkingnum  '(階段1)
                        Case "EventRemoveActualStatusActionOff"
                               執行指令集.執行指令_執行之人物實際狀態消滅無效化_專 uscom, commadtype, atkingnum  '(階段1)
                        Case "EventActiveAIScore"
                               執行指令集.執行指令_智慧型AI個別技能評分 uscom, commadtype, atkingnum  '(階段1)
                     '========================================================
                        Case Else
                               GoTo vss_cmdlocalerr
                End Select
                DoEvents
            Loop Until vbecommadnum(1, vbecommadtotplay) > cmdnumnow
        End If
     Loop
'=============================
Exit Sub
vss_cmdlocalerr:
執行指令集.執行指令集_錯誤訊息通知 "Run-CommadNotFound[" & commadstr2(0) & "]", 0, vbecommadnum(4, vbecommadtotplay)
End Sub
Sub 執行指令集總程序執行(ByVal cmdstr As String, ByVal vsscnum As Integer, ByVal uscom As Integer, ByVal atkingnum As Integer, ByVal ns As Integer)
     Dim commadtype As Integer
     vbecommadnum(3, vbecommadtotplay) = vsscnum
     vbecommadnum(4, vbecommadtotplay) = ns
     執行指令集.執行指令集總程序_擷取指令 cmdstr, ns
     '===================(如果該執行階段屬特殊階段的話)
    If ns >= 60 And ns <= 69 Then '(特殊)
        commadtype = 2
    ElseIf ns >= 40 And ns <= 49 Then   '(一般2型)
        commadtype = 3
    Else
        commadtype = 1
    End If
     '===================
     執行指令集.執行指令集總程序_指令呼叫執行 uscom, commadtype, atkingnum, ns
     執行指令集總程序_執行階段結束 ns
End Sub
Sub 執行指令_技能燈控制(ByVal uscom As Integer, ByVal commadtype As Integer, ByVal atkingnum As Integer)
    If Formsetting.checktest.Value = 0 Then On Error GoTo vss_cmdlocalerr
    commadstr3 = Split(vbecommadstr(3, vbecommadtotplay), ",")
    If UBound(commadstr3) <> 0 Or vbecommadnum(3, vbecommadtotplay) > 48 Or _
        (commadtype <> 1 And (vbecommadnum(4, vbecommadtotplay) < 42 Or vbecommadnum(4, vbecommadtotplay) > 44)) Then GoTo VssCommadExit
    Select Case vbecommadnum(2, vbecommadtotplay)
        Case 1
            Select Case vbecommadnum(3, vbecommadtotplay)
                Case Is <= 12 '==主動技-使用者方
                        If ((uscom = 1 And liveus(角色人物對戰人數(uscom, 2)) <= 0) Or _
                           (uscom = 2 And livecom(角色人物對戰人數(uscom, 2)) <= 0)) And Val(commadstr3(0)) = 1 Then
                           GoTo VssCommadExit
                        End If
                        Select Case Val(commadstr3(0))
                            Case 1
                                戰鬥系統類.人物技能欄燈開關 True, atkingnum
                            Case 2
                                戰鬥系統類.人物技能欄燈開關 False, atkingnum
                        End Select
                Case Is <= 24
                        GoTo VssCommadExit
                Case Is <= 48 '==被動技
                        Dim vspassivenum As Integer
                        If vbecommadnum(3, vbecommadtotplay) - 24 - 12 <= 0 Then
                           vspassivenum = Int((vbecommadnum(3, vbecommadtotplay) - 24) / 4 + 0.9)
                        Else
                          vspassivenum = Int((vbecommadnum(3, vbecommadtotplay) - 24 - 12) / 4 + 0.9)
                        End If
                        '========================
                        If ((uscom = 1 And liveus(vspassivenum) <= 0) Or _
                           (uscom = 2 And livecom(vspassivenum) <= 0)) And Val(commadstr3(0)) = 1 Then
                           GoTo VssCommadExit
                        End If
                        If 角色人物對戰人數(uscom, 2) = vspassivenum Then
                            Select Case uscom
                                Case 1
                                     Select Case Val(commadstr3(0))
                                        Case 1
                                            FormMainMode.PEAFInterface.Passive_使用者_技能燈發亮 = atkingnum - 4
                                        Case 2
                                            FormMainMode.PEAFInterface.Passive_使用者_技能燈變暗 = atkingnum - 4
                                      End Select
                                Case 2
                                      Select Case Val(commadstr3(0))
                                        Case 1
                                            FormMainMode.PEAFInterface.Passive_電腦_技能燈發亮 = atkingnum - 4
                                        Case 2
                                            FormMainMode.PEAFInterface.Passive_電腦_技能燈變暗 = atkingnum - 4
                                      End Select
                            End Select
                        End If
            End Select
            GoTo VssCommadExit
    End Select
    '============================
    Exit Sub
VssCommadExit:
    執行指令集.執行指令_指令結束標記
    '============================
'=============================
Exit Sub
vss_cmdlocalerr:
執行指令集.執行指令集_錯誤訊息通知 "AtkingLineLight", vbecommadnum(2, vbecommadtotplay), vbecommadnum(4, vbecommadtotplay)
End Sub
Sub 執行指令_技能啟動碼控制(ByVal uscom As Integer, ByVal commadtype As Integer, ByVal atkingnum As Integer)
    If Formsetting.checktest.Value = 0 Then On Error GoTo vss_cmdlocalerr
    commadstr3 = Split(vbecommadstr(3, vbecommadtotplay), ",")
    If UBound(commadstr3) <> 0 Or vbecommadnum(3, vbecommadtotplay) > 48 Or _
       (commadtype <> 1 And (vbecommadnum(4, vbecommadtotplay) < 42 Or vbecommadnum(4, vbecommadtotplay) > 44)) Then GoTo VssCommadExit
    Select Case vbecommadnum(2, vbecommadtotplay)
        Case 1
            Select Case vbecommadnum(3, vbecommadtotplay)
                Case Is <= 24 '==主動技
                        If ((uscom = 1 And liveus(角色人物對戰人數(uscom, 2)) <= 0) Or _
                           (uscom = 2 And livecom(角色人物對戰人數(uscom, 2)) <= 0)) And Val(commadstr3(0)) = 1 Then
                           GoTo VssCommadExit
                        End If
                        Select Case Val(commadstr3(0))
                            Case 1
                                atkingck(uscom, 角色人物對戰人數(uscom, 2), atkingnum, 1) = 1
                            Case 2
                                atkingck(uscom, 角色人物對戰人數(uscom, 2), atkingnum, 1) = 0
                                atkingck(uscom, 角色人物對戰人數(uscom, 2), atkingnum, 2) = Val(atkingck(uscom, 角色人物對戰人數(uscom, 2), atkingnum, 2)) + 1
                                atkingck(uscom, 角色人物對戰人數(uscom, 2), atkingnum, 3) = Val(atkingck(uscom, 角色人物對戰人數(uscom, 2), atkingnum, 3)) + 1
                        End Select
                Case Is <= 48 '==被動技
                        Dim vspassivenum As Integer
                        If vbecommadnum(3, vbecommadtotplay) - 24 - 12 <= 0 Then
                           vspassivenum = Int((vbecommadnum(3, vbecommadtotplay) - 24) / 4 + 0.9)
                        Else
                          vspassivenum = Int((vbecommadnum(3, vbecommadtotplay) - 24 - 12) / 4 + 0.9)
                        End If
                        '====================================
                        If ((uscom = 1 And liveus(vspassivenum) <= 0) Or _
                           (uscom = 2 And livecom(vspassivenum) <= 0)) And Val(commadstr3(0)) = 1 Then
                           GoTo VssCommadExit
                        End If
                        Select Case Val(commadstr3(0))
                            Case 1
                                atkingck(uscom, vspassivenum, atkingnum, 1) = 1
                            Case 2
                                atkingck(uscom, vspassivenum, atkingnum, 1) = 0
                                atkingck(uscom, vspassivenum, atkingnum, 2) = Val(atkingck(uscom, vspassivenum, atkingnum, 2)) + 1
                                atkingck(uscom, vspassivenum, atkingnum, 3) = Val(atkingck(uscom, vspassivenum, atkingnum, 3)) + 1
                        End Select
            End Select
            GoTo VssCommadExit
    End Select
        '============================
    Exit Sub
VssCommadExit:
    執行指令集.執行指令_指令結束標記
    '============================
'=============================
Exit Sub
vss_cmdlocalerr:
執行指令集.執行指令集_錯誤訊息通知 "AtkingTurnOnOff", vbecommadnum(2, vbecommadtotplay), vbecommadnum(4, vbecommadtotplay)
End Sub
Sub 執行指令_總骰數變化量控制(ByVal uscom As Integer, ByVal commadtype As Integer, ByVal atkingnum As Integer)
    If Formsetting.checktest.Value = 0 Then On Error GoTo vss_cmdlocalerr
    commadstr3 = Split(vbecommadstr(3, vbecommadtotplay), ",")
    If UBound(commadstr3) <> 2 Or vbecommadnum(4, vbecommadtotplay) <> 45 Then GoTo VssCommadExit
    Dim uscomt As Integer
    Select Case vbecommadnum(2, vbecommadtotplay)
        Case 1
            Select Case commadstr3(1)
                Case 1
                     Select Case Val(commadstr3(0))
                          Case 1
                                uscomt = uscom
                          Case 2
                                If uscom = 1 Then uscomt = 2 Else uscomt = 1
                     End Select
                     If vbecommadnum(3, vbecommadtotplay) <= 24 Then
                         atkingckdice(uscom, uscomt, 1) = atkingckdice(uscom, uscomt, 1) & "+" & commadstr3(2) & "="
                     ElseIf vbecommadnum(3, vbecommadtotplay) > 24 And vbecommadnum(3, vbecommadtotplay) <= 48 Then
                         atkingckdice(uscom, uscomt, 2) = atkingckdice(uscom, uscomt, 2) & "+" & commadstr3(2) & "="
                     ElseIf vbecommadnum(3, vbecommadtotplay) > 48 And vbecommadnum(3, vbecommadtotplay) <= 54 Then
                         atkingckdice(uscom, uscomt, 4) = atkingckdice(uscom, uscomt, 4) & "+" & commadstr3(2) & "="
                     Else
                         atkingckdice(uscom, uscomt, 3) = atkingckdice(uscom, uscomt, 3) & "+" & commadstr3(2) & "="
                     End If
                Case 2
                     Select Case Val(commadstr3(0))
                          Case 1
                                uscomt = uscom
                          Case 2
                                If uscom = 1 Then uscomt = 2 Else uscomt = 1
                     End Select
                     If vbecommadnum(3, vbecommadtotplay) <= 24 Then
                         atkingckdice(uscom, uscomt, 1) = atkingckdice(uscom, uscomt, 1) & "-" & commadstr3(2) & "="
                     ElseIf vbecommadnum(3, vbecommadtotplay) > 24 And vbecommadnum(3, vbecommadtotplay) <= 48 Then
                         atkingckdice(uscom, uscomt, 2) = atkingckdice(uscom, uscomt, 2) & "-" & commadstr3(2) & "="
                     ElseIf vbecommadnum(3, vbecommadtotplay) > 48 And vbecommadnum(3, vbecommadtotplay) <= 54 Then
                         atkingckdice(uscom, uscomt, 4) = atkingckdice(uscom, uscomt, 4) & "-" & commadstr3(2) & "="
                     Else
                         atkingckdice(uscom, uscomt, 3) = atkingckdice(uscom, uscomt, 3) & "-" & commadstr3(2) & "="
                     End If
                Case 3
                     Select Case Val(commadstr3(0))
                          Case 1
                                uscomt = uscom
                          Case 2
                                If uscom = 1 Then uscomt = 2 Else uscomt = 1
                     End Select
                     If vbecommadnum(3, vbecommadtotplay) <= 24 Then
                         atkingckdice(uscom, uscomt, 1) = atkingckdice(uscom, uscomt, 1) & "*" & commadstr3(2) & "="
                     ElseIf vbecommadnum(3, vbecommadtotplay) > 24 And vbecommadnum(3, vbecommadtotplay) <= 48 Then
                         atkingckdice(uscom, uscomt, 2) = atkingckdice(uscom, uscomt, 2) & "*" & commadstr3(2) & "="
                     ElseIf vbecommadnum(3, vbecommadtotplay) > 48 And vbecommadnum(3, vbecommadtotplay) <= 54 Then
                         atkingckdice(uscom, uscomt, 4) = atkingckdice(uscom, uscomt, 4) & "*" & commadstr3(2) & "="
                     Else
                         atkingckdice(uscom, uscomt, 3) = atkingckdice(uscom, uscomt, 3) & "*" & commadstr3(2) & "="
                     End If
                Case 4
                     Select Case Val(commadstr3(0))
                          Case 1
                                uscomt = uscom
                          Case 2
                                If uscom = 1 Then uscomt = 2 Else uscomt = 1
                     End Select
                     If vbecommadnum(3, vbecommadtotplay) <= 24 Then
                         atkingckdice(uscom, uscomt, 1) = atkingckdice(uscom, uscomt, 1) & "\" & commadstr3(2) & "="
                     ElseIf vbecommadnum(3, vbecommadtotplay) > 24 And vbecommadnum(3, vbecommadtotplay) <= 48 Then
                         atkingckdice(uscom, uscomt, 2) = atkingckdice(uscom, uscomt, 2) & "\" & commadstr3(2) & "="
                     ElseIf vbecommadnum(3, vbecommadtotplay) > 48 And vbecommadnum(3, vbecommadtotplay) <= 54 Then
                         atkingckdice(uscom, uscomt, 4) = atkingckdice(uscom, uscomt, 4) & "\" & commadstr3(2) & "="
                     Else
                         atkingckdice(uscom, uscomt, 3) = atkingckdice(uscom, uscomt, 3) & "\" & commadstr3(2) & "="
                     End If
                Case 5
                     Select Case Val(commadstr3(0))
                          Case 1
                                uscomt = uscom
                          Case 2
                                If uscom = 1 Then uscomt = 2 Else uscomt = 1
                     End Select
                     If vbecommadnum(3, vbecommadtotplay) <= 24 Then
                         atkingckdice(uscom, uscomt, 1) = atkingckdice(uscom, uscomt, 1) & "/" & commadstr3(2) & "="
                     ElseIf vbecommadnum(3, vbecommadtotplay) > 24 And vbecommadnum(3, vbecommadtotplay) <= 48 Then
                         atkingckdice(uscom, uscomt, 2) = atkingckdice(uscom, uscomt, 2) & "/" & commadstr3(2) & "="
                     ElseIf vbecommadnum(3, vbecommadtotplay) > 48 And vbecommadnum(3, vbecommadtotplay) <= 54 Then
                         atkingckdice(uscom, uscomt, 4) = atkingckdice(uscom, uscomt, 4) & "/" & commadstr3(2) & "="
                     Else
                         atkingckdice(uscom, uscomt, 3) = atkingckdice(uscom, uscomt, 3) & "/" & commadstr3(2) & "="
                     End If
                Case 6
                     Select Case Val(commadstr3(0))
                          Case 1
                                uscomt = uscom
                          Case 2
                                If uscom = 1 Then uscomt = 2 Else uscomt = 1
                     End Select
                     If vbecommadnum(3, vbecommadtotplay) <= 24 Then
                         atkingckdice(uscom, uscomt, 1) = atkingckdice(uscom, uscomt, 1) & "@" & commadstr3(2) & "="
                     ElseIf vbecommadnum(3, vbecommadtotplay) > 24 And vbecommadnum(3, vbecommadtotplay) <= 48 Then
                         atkingckdice(uscom, uscomt, 2) = atkingckdice(uscom, uscomt, 2) & "@" & commadstr3(2) & "="
                     ElseIf vbecommadnum(3, vbecommadtotplay) > 48 And vbecommadnum(3, vbecommadtotplay) <= 54 Then
                         atkingckdice(uscom, uscomt, 4) = atkingckdice(uscom, uscomt, 4) & "@" & commadstr3(2) & "="
                     Else
                         atkingckdice(uscom, uscomt, 3) = atkingckdice(uscom, uscomt, 3) & "@" & commadstr3(2) & "="
                     End If
            End Select
'            戰鬥系統類.骰量更新顯示
            GoTo VssCommadExit
    End Select
        '============================
    Exit Sub
VssCommadExit:
    執行指令集.執行指令_指令結束標記
    '============================
'=============================
Exit Sub
vss_cmdlocalerr:
執行指令集.執行指令集_錯誤訊息通知 "EventTotalDiceChange", vbecommadnum(2, vbecommadtotplay), vbecommadnum(4, vbecommadtotplay)
End Sub
Sub 執行指令_總骰數總量控制(ByVal uscom As Integer, ByVal commadtype As Integer, ByVal atkingnum As Integer)
    If Formsetting.checktest.Value = 0 Then On Error GoTo vss_cmdlocalerr
    commadstr3 = Split(vbecommadstr(3, vbecommadtotplay), ",")
    If UBound(commadstr3) <> 2 Or (commadtype <> 1 And vbecommadnum(4, vbecommadtotplay) <> 61) Then GoTo VssCommadExit
    Dim uscomt As Integer
    Select Case vbecommadnum(2, vbecommadtotplay)
        Case 1
            Select Case commadstr3(1)
                Case 1
                     Select Case Val(commadstr3(0))
                          Case 1
                                uscomt = uscom
                          Case 2
                                If uscom = 1 Then uscomt = 2 Else uscomt = 1
                     End Select
                     攻擊防禦骰子總數(uscomt) = 攻擊防禦骰子總數(uscomt) + Val(commadstr3(2))
                Case 2
                     Select Case Val(commadstr3(0))
                          Case 1
                                uscomt = uscom
                          Case 2
                                If uscom = 1 Then uscomt = 2 Else uscomt = 1
                     End Select
                     攻擊防禦骰子總數(uscomt) = 攻擊防禦骰子總數(uscomt) - Val(commadstr3(2))
                Case 3
                     Select Case Val(commadstr3(0))
                          Case 1
                                uscomt = uscom
                          Case 2
                                If uscom = 1 Then uscomt = 2 Else uscomt = 1
                     End Select
                     攻擊防禦骰子總數(uscomt) = 攻擊防禦骰子總數(uscomt) * Val(commadstr3(2))
                Case 4
                     Select Case Val(commadstr3(0))
                          Case 1
                                uscomt = uscom
                          Case 2
                                If uscom = 1 Then uscomt = 2 Else uscomt = 1
                     End Select
                     攻擊防禦骰子總數(uscomt) = 攻擊防禦骰子總數(uscomt) \ Val(commadstr3(2))
                Case 5
                     Select Case Val(commadstr3(0))
                          Case 1
                                uscomt = uscom
                          Case 2
                                If uscom = 1 Then uscomt = 2 Else uscomt = 1
                     End Select
                     攻擊防禦骰子總數(uscomt) = Int(攻擊防禦骰子總數(uscomt) / Val(commadstr3(2)) + 0.9)
                Case 6
                     Select Case Val(commadstr3(0))
                          Case 1
                                uscomt = uscom
                          Case 2
                                If uscom = 1 Then uscomt = 2 Else uscomt = 1
                     End Select
                     攻擊防禦骰子總數(uscomt) = Val(commadstr3(2))
            End Select
'            戰鬥系統類.骰量更新顯示
            GoTo VssCommadExit
    End Select
        '============================
    Exit Sub
VssCommadExit:
    執行指令集.執行指令_指令結束標記
    '============================
'=============================
Exit Sub
vss_cmdlocalerr:
執行指令集.執行指令集_錯誤訊息通知 "PersonTotalDiceControl", vbecommadnum(2, vbecommadtotplay), vbecommadnum(4, vbecommadtotplay)
End Sub

Sub 執行指令_人物血量控制(ByVal uscom As Integer, ByVal commadtype As Integer, ByVal atkingnum As Integer)
    If Formsetting.checktest.Value = 0 Then On Error GoTo vss_cmdlocalerr
    commadstr3 = Split(vbecommadstr(3, vbecommadtotplay), ",")
    If UBound(commadstr3) <> 3 Or commadtype = 3 Then GoTo VssCommadExit
    Dim uscomt As Integer
    Select Case vbecommadnum(2, vbecommadtotplay)
        Case 1
            Select Case commadstr3(2)
                Case 1
                     Select Case Val(commadstr3(0))
                          Case 1
                                uscomt = uscom
                          Case 2
                                If uscom = 1 Then uscomt = 2 Else uscomt = 1
                     End Select
                     Select Case uscomt
                          Case 1
                                戰鬥系統類.傷害執行_技能直傷_使用者 commadstr3(3), commadstr3(1)
                          Case 2
                                戰鬥系統類.傷害執行_技能直傷_電腦 commadstr3(3), commadstr3(1)
                     End Select
                Case 2
                     Select Case Val(commadstr3(0))
                          Case 1
                                uscomt = uscom
                          Case 2
                                If uscom = 1 Then uscomt = 2 Else uscomt = 1
                     End Select
                     Select Case uscomt
                          Case 1
                                戰鬥系統類.回復執行_使用者 commadstr3(3), commadstr3(1)
                          Case 2
                                戰鬥系統類.回復執行_電腦 commadstr3(3), commadstr3(1)
                     End Select
                Case 3
                     Select Case Val(commadstr3(0))
                          Case 1
                                uscomt = uscom
                          Case 2
                                If uscom = 1 Then uscomt = 2 Else uscomt = 1
                     End Select
                     Select Case uscomt
                          Case 1
                                戰鬥系統類.傷害執行_立即死亡_使用者 commadstr3(1)
                          Case 2
                                戰鬥系統類.傷害執行_立即死亡_電腦 commadstr3(1)
                     End Select
            End Select
            GoTo VssCommadExit
    End Select
        '============================
    Exit Sub
VssCommadExit:
    執行指令集.執行指令_指令結束標記
    '============================
'=============================
Exit Sub
vss_cmdlocalerr:
執行指令集.執行指令集_錯誤訊息通知 "PersonBloodControl", vbecommadnum(2, vbecommadtotplay), vbecommadnum(4, vbecommadtotplay)
End Sub
Sub 執行指令_人物技能無效化(ByVal uscom As Integer, ByVal commadtype As Integer, ByVal atkingnum As Integer)
    If Formsetting.checktest.Value = 0 Then On Error GoTo vss_cmdlocalerr
    commadstr3 = Split(vbecommadstr(3, vbecommadtotplay), ",")
    If UBound(commadstr3) <> 1 Or (commadtype <> 1 And vbecommadnum(4, vbecommadtotplay) <> 61) Then GoTo VssCommadExit
    Dim uscomt As Integer
    Select Case Val(commadstr3(0))
         Case 1
               uscomt = uscom
         Case 2
               If uscom = 1 Then uscomt = 2 Else uscomt = 1
    End Select
    Select Case vbecommadnum(2, vbecommadtotplay)
        Case 1
            Select Case commadstr3(1)
                Case 1 '==主動技
                        For i = 1 To 4
                            atkingck(uscomt, 角色人物對戰人數(uscomt, 2), i, 1) = 0
                            戰鬥系統類.人物技能欄燈開關 False, i
                        Next
                        atkingckdice(uscomt, uscom, 1) = 0
                        atkingckdice(uscomt, uscomt, 1) = 0
                Case 2 '==被動技
                        For i = 5 To 8
                            atkingck(uscomt, 角色人物對戰人數(uscomt, 2), i, 1) = 0
                        Next
                        atkingckdice(uscomt, uscom, 2) = 0
                        atkingckdice(uscomt, uscomt, 2) = 0
            End Select
            戰鬥系統類.骰量更新顯示
            '============
            FormMainMode.trgoi1_Timer
            FormMainMode.trgoi2_Timer
            '============
            GoTo VssCommadExit
    End Select
        '============================
    Exit Sub
VssCommadExit:
    執行指令集.執行指令_指令結束標記
    '============================
'=============================
Exit Sub
vss_cmdlocalerr:
執行指令集.執行指令集_錯誤訊息通知 "PersonAtkingInvalid", vbecommadnum(2, vbecommadtotplay), vbecommadnum(4, vbecommadtotplay)
End Sub
Sub 執行指令_場地距離控制(ByVal uscom As Integer, ByVal commadtype As Integer, ByVal atkingnum As Integer)
    If Formsetting.checktest.Value = 0 Then On Error GoTo vss_cmdlocalerr
    commadstr3 = Split(vbecommadstr(3, vbecommadtotplay), ",")
    If UBound(commadstr3) <> 0 Or commadtype = 3 Then GoTo VssCommadExit
    Select Case vbecommadnum(2, vbecommadtotplay)
        Case 1
            Select Case Val(commadstr3(0))
                Case 1
                    戰鬥系統類.執行動作_距離變更 1
                Case 2
                    戰鬥系統類.執行動作_距離變更 2
                Case 3
                    戰鬥系統類.執行動作_距離變更 3
            End Select
            GoTo VssCommadExit
    End Select
    '============================
    Exit Sub
VssCommadExit:
    執行指令集.執行指令_指令結束標記
    '============================
'=============================
Exit Sub
vss_cmdlocalerr:
執行指令集.執行指令集_錯誤訊息通知 "BattleMoveControl", vbecommadnum(2, vbecommadtotplay), vbecommadnum(4, vbecommadtotplay)
End Sub
Sub 執行指令_技能動畫執行(ByVal uscom As Integer, ByVal commadtype As Integer, ByVal atkingnum As Integer)
    If Formsetting.checktest.Value = 0 Then On Error GoTo vss_cmdlocalerr
    commadstr3 = Split(vbecommadstr(3, vbecommadtotplay), ",")
    If UBound(commadstr3) <> 1 Or commadtype <> 1 Or atkingnum = 9 Or (vbecommadnum(4, vbecommadtotplay) = 13 Or vbecommadnum(4, vbecommadtotplay) = 33) Then GoTo VssCommadExit
    Select Case vbecommadnum(2, vbecommadtotplay)
        Case 1
            Select Case uscom
                Case 1 '==使用者方
                        Formatkingus.atkingusjpg.LoadImage_FromFile App.Path & commadstr3(0)
                        Formatkingcom.atkingcomjpg.Mirror = aiMirrorNone
                        Formatkingus.atkingusjpg.Visible = False
                        Formatkingus.atkingusjpg.ScaleMethod = aiActualSize
                        Formatkingus.atkingusjpg.Left = 0
                        Formatkingus.atkingusjpg.Top = 0
                        Formatkingus.Width = Formatkingus.atkingusjpg.Width + 60
                        Formatkingus.Height = Formatkingus.atkingusjpg.Height + 420
                        目前數(29) = 0
                        FormMainMode.atkingtrus.Enabled = True
                Case 2 '==電腦方
                        Formatkingcom.atkingcomjpg.LoadImage_FromFile App.Path & commadstr3(0)
                        Formatkingcom.atkingcomjpg.Mirror = aiMirrorHorizontal
                        Formatkingcom.atkingcomjpg.Visible = False
                        Formatkingcom.atkingcomjpg.ScaleMethod = aiActualSize
                        Formatkingcom.atkingcomjpg.Left = 0
                        Formatkingcom.atkingcomjpg.Top = 0
                        Formatkingcom.Width = Formatkingcom.atkingcomjpg.Width + 60
                        Formatkingcom.Height = Formatkingcom.atkingcomjpg.Height + 420
                        目前數(29) = 0
                        FormMainMode.atkingtrcom.Enabled = True
            End Select
            Erase Vss_AtkingStartPlayNum
'            vbecommadnum(2, vbecommadtotplay) = 0 '==等待時間
            vbecommadnum(2, vbecommadtotplay) = 2 '==等待時間
        Case 2
            If Vss_AtkingStartPlayNum(1) = 1 Then
                Select Case uscom
                    Case 1 '==使用者方
                            If commadstr3(1) <> "0" Then
                                Formatkingus.atkingusjpg.LoadImage_FromFile App.Path & commadstr3(1)
                            End If
                    Case 2 '==電腦方
                            If commadstr3(1) <> "0" Then
                                Formatkingcom.atkingcomjpg.LoadImage_FromFile App.Path & commadstr3(1)
                            End If
                End Select
'                vbecommadnum(2, vbecommadtotplay) = 0 '==等待時間
                vbecommadnum(2, vbecommadtotplay) = 3 '==等待時間
            End If
        Case 3
            If Vss_AtkingStartPlayNum(2) = 1 Then
                '=======================
                執行階段系統_宣告開始或結束 1
                '=======================
                Dim VBEStageNumMain(1 To 5) As Integer
                Dim personnum As Integer, persontype As Integer
                Dim buffvssnum As String
                If vbecommadnum(3, vbecommadtotplay - 1) <= 24 Then
                    執行階段系統類.執行階段系統總主要程序_人物主動技能 uscom, atkingnum, 61, VBEStageNumMain
                ElseIf vbecommadnum(3, vbecommadtotplay - 1) > 24 And vbecommadnum(3, vbecommadtotplay - 1) <= 48 Then
                    If vbecommadnum(3, vbecommadtotplay - 1) - 24 - 12 <= 0 Then
                       personnum = Int((vbecommadnum(3, vbecommadtotplay - 1) - 24) / 4 + 0.9)
                    Else
                      personnum = Int((vbecommadnum(3, vbecommadtotplay - 1) - 24 - 12) / 4 + 0.9)
                    End If
                    If 角色人物對戰人數(uscom, 2) = personnum Then persontype = 1 Else persontype = 2
                    '================================
                    執行階段系統類.執行階段系統總主要程序_人物被動技能 uscom, personnum, atkingnum, 61, persontype, VBEStageNumMain
                ElseIf vbecommadnum(3, vbecommadtotplay - 1) > 48 And vbecommadnum(3, vbecommadtotplay - 1) <= 54 Then
                    If vbecommadnum(3, vbecommadtotplay - 1) - 48 > 3 Then
                        personnum = vbecommadnum(3, vbecommadtotplay - 1) - 48 - 3
                    Else
                        personnum = vbecommadnum(3, vbecommadtotplay - 1) - 48
                    End If
                    If 角色人物對戰人數(uscom, 2) = personnum Then persontype = 1 Else persontype = 2
                    '=================================
                    執行階段系統類.執行階段系統總主要程序_人物實際狀態 uscom, personnum, 61, persontype, VBEStageNumMain
                Else
                    buffvssnum = VBEVSSBuffStr1(vbecommadnum(3, vbecommadtotplay - 1) - 54)
                    For i = 1 To 14
                        If 人物異常狀態資料庫(uscom, vbecommadnum(7, vbecommadtotplay - 1), i, 3) = buffvssnum And Val(人物異常狀態資料庫(uscom, vbecommadnum(7, vbecommadtotplay - 1), i, 2)) > 0 Then
                            執行階段系統類.執行階段系統總主要程序_異常狀態 uscom, vbecommadnum(7, vbecommadtotplay - 1), i, 61, vbecommadnum(6, vbecommadtotplay - 1), VBEStageNumMain
                            Exit For
                        End If
                    Next
                End If
                '=======================
                執行階段系統_宣告開始或結束 2
'                vbecommadnum(2, vbecommadtotplay) = 0 '==等待時間
                vbecommadnum(2, vbecommadtotplay) = 4 '==等待時間
            End If
        Case 4
            If Vss_AtkingStartPlayNum(3) = 1 Then
                GoTo VssCommadExit
            End If
    End Select
    '============================
    Exit Sub
VssCommadExit:
'    vbecommadnum(1,vbecommadtotplay) = vbecommadnum(5,vbecommadtotplay)  '==宣告結束目前之執行階段
    執行指令集.執行指令_指令結束標記
    '============================
'=============================
Exit Sub
vss_cmdlocalerr:
執行指令集.執行指令集_錯誤訊息通知 "AtkingStartPlay", vbecommadnum(2, vbecommadtotplay), vbecommadnum(4, vbecommadtotplay)
End Sub
Sub 執行指令_奪取對手卡牌(ByVal uscom As Integer, ByVal commadtype As Integer, ByVal atkingnum As Integer)
    If Formsetting.checktest.Value = 0 Then On Error GoTo vss_cmdlocalerr
    commadstr3 = Split(vbecommadstr(3, vbecommadtotplay), ",")
    If UBound(commadstr3) <> 1 Or (commadtype <> 1 And vbecommadnum(4, vbecommadtotplay) <> 61) Then GoTo VssCommadExit
    Dim uscomt As Integer
    Select Case uscom
         Case 1
               uscomt = 2
         Case 2
               uscomt = 1
    End Select
    Select Case vbecommadnum(2, vbecommadtotplay)
        Case 1
             Select Case Val(commadstr3(0))
                  Case 1  '==手牌
                        Select Case uscomt
                             Case 1
                                    If Val(pagecardnum(Val(commadstr3(1)), 6)) = 1 And Val(pagecardnum(Val(commadstr3(1)), 5)) = 1 Then
                                        目前數(20) = Val(commadstr3(1))
                                        目前數(21) = 2
                                        FormMainMode.tr使用者牌_偷牌.Enabled = True
                                        vbecommadnum(2, vbecommadtotplay) = 0
                                    Else
                                        GoTo VssCommadExit
                                    End If
                             Case 2
                                    If Val(pagecardnum(Val(commadstr3(1)), 6)) = 1 And Val(pagecardnum(Val(commadstr3(1)), 5)) = 2 Then
                                        目前數(16) = Val(commadstr3(1))
                                        FormMainMode.tr電腦牌_翻牌.Enabled = True
                                        vbecommadnum(2, vbecommadtotplay) = 0
                                    Else
                                        GoTo VssCommadExit
                                    End If
                        End Select
                  Case 2  '==出牌
                        Select Case uscomt
                               Case 1
                                    If Val(pagecardnum(Val(commadstr3(1)), 6)) = 2 And Val(pagecardnum(Val(commadstr3(1)), 5)) = 1 Then
                                         turnpageoninatking = 1
                                         FormMainMode.card_CardClick (Val(commadstr3(1)))
                                         vbecommadnum(2, vbecommadtotplay) = 0
                                     Else
                                         GoTo VssCommadExit
                                     End If
                               Case 2
                                    If Val(pagecardnum(Val(commadstr3(1)), 6)) = 2 And Val(pagecardnum(Val(commadstr3(1)), 5)) = 2 Then
                                         戰鬥系統類.電腦牌_模擬按牌_外 Val(commadstr3(1))
                                         vbecommadnum(2, vbecommadtotplay) = 0
                                     Else
                                         GoTo VssCommadExit
                                     End If
                            End Select
             End Select
        Case 2
            Select Case Val(commadstr3(0))
                 Case 1  '==手牌
                        Select Case uscomt
                             Case 1
                                   GoTo VssCommadExit
                             Case 2
                                   目前數(17) = 3
                                    FormMainMode.tr電腦牌_偷牌.Enabled = True
                                    vbecommadnum(2, vbecommadtotplay) = 0
                        End Select
                 Case 2  '==出牌
                        Select Case uscomt
                             Case 1
                                    目前數(21) = 1
                                    Vss_AtkingSeizeEnemyCardsNum = 目前數(5)
                                    '=========將座標指定至電腦手牌
                                    戰鬥系統類.座標計算_電腦手牌
                                    戰鬥系統類.執行動作_使用者牌_偷牌_電腦 Val(commadstr3(1))
                                    目前數(5) = Vss_AtkingSeizeEnemyCardsNum
                                    目前數(15) = 23
                                    turnpageoninatking = 0
                                    vbecommadnum(2, vbecommadtotplay) = 0
                             Case 2
                                    目前數(17) = 2
                                    Vss_AtkingSeizeEnemyCardsNum = 目前數(9)
                                    '=========將座標指定至使用者手牌
                                    戰鬥系統類.座標計算_使用者手牌
                                    戰鬥系統類.執行動作_電腦牌_偷牌_使用者 Val(commadstr3(1))
                                    戰鬥系統類.公用牌回復正面 Val(commadstr3(1))
                                    目前數(9) = Vss_AtkingSeizeEnemyCardsNum
                                    目前數(15) = 23
                                    vbecommadnum(2, vbecommadtotplay) = 0
                        End Select
            End Select
        Case 3
            Select Case Val(commadstr3(0))
                 Case 1  '==手牌
                       GoTo VssCommadExit
                 Case 2  '==出牌
                       GoTo VssCommadExit
            End Select
    End Select
        '============================
    Exit Sub
VssCommadExit:
    執行指令集.執行指令_指令結束標記
    '============================
'=============================
Exit Sub
vss_cmdlocalerr:
執行指令集.執行指令集_錯誤訊息通知 "AtkingSeizeEnemyCards", vbecommadnum(2, vbecommadtotplay), vbecommadnum(4, vbecommadtotplay)
End Sub
Sub 執行指令_技能抽牌(ByVal uscom As Integer, ByVal commadtype As Integer, ByVal atkingnum As Integer)
    If Formsetting.checktest.Value = 0 Then On Error GoTo vss_cmdlocalerr
    commadstr3 = Split(vbecommadstr(3, vbecommadtotplay), ",")
    Dim tn As Integer '暫時變數
    If UBound(commadstr3) <> 1 Or (commadtype <> 1 And vbecommadnum(4, vbecommadtotplay) <> 61) Then GoTo VssCommadExit
    Select Case vbecommadnum(2, vbecommadtotplay)
        Case 1
             Vss_AtkingDrawCardsNum = Vss_AtkingDrawCardsNum + 1
             If Vss_AtkingDrawCardsNum = 1 Then
                 If BattleCardNum < Val(commadstr3(1)) Then
                   戰鬥系統類.執行動作_洗牌
                End If
             End If
             If Vss_AtkingDrawCardsNum <= Val(commadstr3(1)) Then
                    Select Case Val(commadstr3(0))
                         Case 1  '==公用牌
                               Select Case uscom
                                    Case 1
                                           目前數(15) = 21
                                           FormMainMode.tr牌組_抽牌_使用者.Enabled = True
                                           vbecommadnum(2, vbecommadtotplay) = 0
                                    Case 2
                                          目前數(15) = 21
                                           FormMainMode.tr牌組_抽牌_電腦.Enabled = True
                                           vbecommadnum(2, vbecommadtotplay) = 0
                               End Select
                         Case 2  '==事件卡
                               Select Case uscom
                                    Case 1
                                            tn = BattleTurn + 1
                                            If tn <= 18 Then
                                                If tn <= 事件卡記錄暫時數(0, 1) Or Formsetting.persontgreus.Value = 0 Then
                                                    If pageeventnum(1, tn, 1) <> "" Then
                                                        ay = Split(一般系統類.事件卡資料庫(pageeventnum(1, tn, 1), 3), "=")
                                                        pagecardnum(公用牌實體卡片分隔紀錄數(2) + tn, 1) = ay(0)
                                                        pagecardnum(公用牌實體卡片分隔紀錄數(2) + tn, 2) = ay(1)
                                                        pagecardnum(公用牌實體卡片分隔紀錄數(2) + tn, 3) = ay(2)
                                                        pagecardnum(公用牌實體卡片分隔紀錄數(2) + tn, 4) = ay(3)
                                                        pagecardnum(公用牌實體卡片分隔紀錄數(2) + tn, 5) = 1
                                                        pagecardnum(公用牌實體卡片分隔紀錄數(2) + tn, 6) = 1
                                                        pagecardnum(公用牌實體卡片分隔紀錄數(2) + tn, 8) = pageeventnum(1, tn, 2)
                                                        pagecardnum(公用牌實體卡片分隔紀錄數(2) + tn, 11) = 0
                                                        FormMainMode.card(公用牌實體卡片分隔紀錄數(2) + tn).CardImage = app_path & "card\" & pageeventnum(1, tn, 2) & ".png"
                                                        FormMainMode.card(公用牌實體卡片分隔紀錄數(2) + tn).CardRotationType = 1
                                                        pageonin(公用牌實體卡片分隔紀錄數(2) + tn) = 1
                                                    End If
                                                End If
                                            End If
                                            If BattleTurn < 18 And (tn <= 事件卡記錄暫時數(0, 1) Or Formsetting.persontgreus.Value = 0) Then
                                                目前數(16) = 70 + BattleTurn + 1
                                                BattleTurn = BattleTurn + 1
                                                FormMainMode.PEAFInterface.turn = BattleTurn
                                                目前數(15) = 21
                                                FormMainMode.tr牌組_回牌_使用者.Enabled = True
                                            End If
                                    Case 2
                                            tn = BattleTurn + 1
                                            If tn <= 18 Then
                                                If tn <= 事件卡記錄暫時數(0, 1) Or Formsetting.persontgrecom.Value = 0 Then
                                                    If pageeventnum(2, tn, 1) <> "" Then
                                                        ay = Split(一般系統類.事件卡資料庫(pageeventnum(2, tn, 1), 3), "=")
                                                        pagecardnum(公用牌實體卡片分隔紀錄數(3) + tn, 1) = ay(0)
                                                        pagecardnum(公用牌實體卡片分隔紀錄數(3) + tn, 2) = ay(1)
                                                        pagecardnum(公用牌實體卡片分隔紀錄數(3) + tn, 3) = ay(2)
                                                        pagecardnum(公用牌實體卡片分隔紀錄數(3) + tn, 4) = ay(3)
                                                        pagecardnum(公用牌實體卡片分隔紀錄數(3) + tn, 5) = 2
                                                        pagecardnum(公用牌實體卡片分隔紀錄數(3) + tn, 6) = 1
                                                        pagecardnum(公用牌實體卡片分隔紀錄數(3) + tn, 8) = pageeventnum(2, tn, 2)
                                                        FormMainMode.card(公用牌實體卡片分隔紀錄數(3) + tn).CardImage = app_path & "card\" & pageeventnum(2, tn, 2) & ".png"
                                                        FormMainMode.card(公用牌實體卡片分隔紀錄數(3) + tn).CardRotationType = 1
                                                        pagecardnum(公用牌實體卡片分隔紀錄數(3) + tn, 11) = 0
                                                        pageonin(公用牌實體卡片分隔紀錄數(3) + tn) = 1
                                                    End If
                                                End If
                                            End If
                                            If BattleTurn < 18 And (tn <= 事件卡記錄暫時數(0, 1) Or Formsetting.persontgrecom.Value = 0) Then
                                                目前數(16) = 88 + BattleTurn + 1
                                                BattleTurn = BattleTurn + 1
                                                FormMainMode.PEAFInterface.turn = BattleTurn
                                                目前數(15) = 21
                                                FormMainMode.tr牌組_回牌_電腦.Enabled = True
                                            End If
                               End Select
                    End Select
             ElseIf Vss_AtkingDrawCardsNum > Val(commadstr3(1)) Then
                    Vss_AtkingDrawCardsNum = 0
                    GoTo VssCommadExit
             End If
    End Select
        '============================
    Exit Sub
VssCommadExit:
    執行指令集.執行指令_指令結束標記
    '============================
'=============================
Exit Sub
vss_cmdlocalerr:
執行指令集.執行指令集_錯誤訊息通知 "AtkingDrawCards", vbecommadnum(2, vbecommadtotplay), vbecommadnum(4, vbecommadtotplay)
End Sub
Sub 執行指令_系統強制洗牌(ByVal uscom As Integer, ByVal commadtype As Integer, ByVal atkingnum As Integer)
    If Formsetting.checktest.Value = 0 Then On Error GoTo vss_cmdlocalerr
    commadstr3 = Split(vbecommadstr(3, vbecommadtotplay), ",")
    If UBound(commadstr3) <> 0 Or commadtype = 3 Then GoTo VssCommadExit
    Select Case vbecommadnum(2, vbecommadtotplay)
        Case 1
            戰鬥系統類.執行動作_洗牌
            GoTo VssCommadExit
    End Select
    '============================
    Exit Sub
VssCommadExit:
    執行指令集.執行指令_指令結束標記
    '============================
'=============================
Exit Sub
vss_cmdlocalerr:
執行指令集.執行指令集_錯誤訊息通知 "BattleDeckShuffle", vbecommadnum(2, vbecommadtotplay), vbecommadnum(4, vbecommadtotplay)
End Sub
Sub 執行指令_系統回合數控制(ByVal uscom As Integer, ByVal commadtype As Integer, ByVal atkingnum As Integer)
    If Formsetting.checktest.Value = 0 Then On Error GoTo vss_cmdlocalerr
    commadstr3 = Split(vbecommadstr(3, vbecommadtotplay), ",")
    If UBound(commadstr3) <> 1 Or commadtype = 3 Then GoTo VssCommadExit
    Select Case vbecommadnum(2, vbecommadtotplay)
        Case 1
            Select Case Val(commadstr3(0))
                 Case 1
                       If BattleTurn + Val(commadstr3(1)) <= 18 Then
                          BattleTurn = BattleTurn + Val(commadstr3(1))
                       End If
                 Case 2
                       If BattleTurn - Val(commadstr3(1)) >= 1 Then
                          BattleTurn = BattleTurn - Val(commadstr3(1))
                       End If
            End Select
            FormMainMode.PEAFInterface.turn = BattleTurn
            GoTo VssCommadExit
    End Select
    '============================
    Exit Sub
VssCommadExit:
    執行指令集.執行指令_指令結束標記
    '============================
'=============================
Exit Sub
vss_cmdlocalerr:
執行指令集.執行指令集_錯誤訊息通知 "BattleTurnControl", vbecommadnum(2, vbecommadtotplay), vbecommadnum(4, vbecommadtotplay)
End Sub
Sub 執行指令_擁有卡牌丟牌(ByVal uscom As Integer, ByVal commadtype As Integer, ByVal atkingnum As Integer)
    If Formsetting.checktest.Value = 0 Then On Error GoTo vss_cmdlocalerr
    commadstr3 = Split(vbecommadstr(3, vbecommadtotplay), ",")
    If UBound(commadstr3) <> 1 Or (commadtype <> 1 And vbecommadnum(4, vbecommadtotplay) <> 61) Then GoTo VssCommadExit
    Dim uscomt As Integer
    Select Case Val(commadstr3(0))
         Case 1
               uscomt = uscom
         Case 2
               If uscom = 1 Then uscomt = 2 Else uscomt = 1
    End Select
    Select Case vbecommadnum(2, vbecommadtotplay)
        Case 1
             Select Case uscomt
                  Case 1
                        If Val(pagecardnum(Val(commadstr3(1)), 6)) = 1 And Val(pagecardnum(Val(commadstr3(1)), 5)) = 1 Then
                            目前數(20) = Val(commadstr3(1))
                            目前數(21) = 4
                            FormMainMode.tr使用者_棄牌.Enabled = True
                            vbecommadnum(2, vbecommadtotplay) = 0
                        Else
                            GoTo VssCommadExit
                        End If
                  Case 2
                        If Val(pagecardnum(Val(commadstr3(1)), 6)) = 1 And Val(pagecardnum(Val(commadstr3(1)), 5)) = 2 Then
                            目前數(16) = Val(commadstr3(1))
                            FormMainMode.tr電腦牌_翻牌.Enabled = True
                            vbecommadnum(2, vbecommadtotplay) = 0
                        Else
                            GoTo VssCommadExit
                        End If
             End Select
        Case 2
            Select Case uscomt
                 Case 1
                       GoTo VssCommadExit
                 Case 2
                       FormMainMode.tr電腦牌_棄牌.Enabled = True
                      目前數(17) = 4
                      vbecommadnum(2, vbecommadtotplay) = 0
            End Select
        Case 3
            GoTo VssCommadExit
    End Select
    '============================
    Exit Sub
VssCommadExit:
    執行指令集.執行指令_指令結束標記
    '============================
'=============================
Exit Sub
vss_cmdlocalerr:
執行指令集.執行指令集_錯誤訊息通知 "AtkingDestroyCards", vbecommadnum(2, vbecommadtotplay), vbecommadnum(4, vbecommadtotplay)
End Sub
Sub 執行指令_送與卡牌(ByVal uscom As Integer, ByVal commadtype As Integer, ByVal atkingnum As Integer)
    If Formsetting.checktest.Value = 0 Then On Error GoTo vss_cmdlocalerr
    commadstr3 = Split(vbecommadstr(3, vbecommadtotplay), ",")
    If UBound(commadstr3) <> 1 Or (commadtype <> 1 And vbecommadnum(4, vbecommadtotplay) <> 61) Then GoTo VssCommadExit
    Select Case vbecommadnum(2, vbecommadtotplay)
        Case 1
            If Val(pagecardnum(Val(commadstr3(0)), 6)) = 1 And Val(pagecardnum(Val(commadstr3(0)), 5)) = uscom Then
                Select Case uscom
                     Case 1 '==使用者方
                          目前數(20) = Val(commadstr3(1))
                          目前數(21) = 5
                          FormMainMode.tr使用者牌_偷牌.Enabled = True
                          vbecommadnum(2, vbecommadtotplay) = 0
                     Case 2 '==電腦方
                          目前數(16) = Val(commadstr3(1))
                          FormMainMode.tr電腦牌_翻牌.Enabled = True
                          vbecommadnum(2, vbecommadtotplay) = 0
                End Select
            Else
                GoTo VssCommadExit
            End If
        Case 2
            Select Case uscom
                 Case 1 '==使用者方
                      GoTo VssCommadExit
                 Case 2 '==電腦方
                       目前數(17) = 5
                        FormMainMode.tr電腦牌_偷牌.Enabled = True
                        vbecommadnum(2, vbecommadtotplay) = 0
            End Select
        Case 3
            GoTo VssCommadExit
    End Select
        '============================
    Exit Sub
VssCommadExit:
    執行指令集.執行指令_指令結束標記
    '============================
'=============================
Exit Sub
vss_cmdlocalerr:
執行指令集.執行指令集_錯誤訊息通知 "AtkingGiveCards", vbecommadnum(2, vbecommadtotplay), vbecommadnum(4, vbecommadtotplay)
End Sub
Sub 執行指令_墓地牌回牌(ByVal uscom As Integer, ByVal commadtype As Integer, ByVal atkingnum As Integer)
    If Formsetting.checktest.Value = 0 Then On Error GoTo vss_cmdlocalerr
    commadstr3 = Split(vbecommadstr(3, vbecommadtotplay), ",")
    If UBound(commadstr3) <> 0 Or (commadtype <> 1 And vbecommadnum(4, vbecommadtotplay) <> 61) Then GoTo VssCommadExit
    Select Case vbecommadnum(2, vbecommadtotplay)
        Case 1
             Select Case uscom
                 Case 1
                     If pagecardnum(Val(commadstr3(0)), 6) = 3 Then
                         目前數(16) = Val(commadstr3(0))
                         目前數(15) = 22
                         FormMainMode.tr牌組_回牌_使用者.Enabled = True
                     Else
                         GoTo VssCommadExit
                     End If
                 Case 2
                     If pagecardnum(Val(commadstr3(0)), 6) = 3 Then
                        目前數(16) = Val(commadstr3(0))
                        目前數(15) = 22
                        FormMainMode.tr牌組_回牌_電腦.Enabled = True
                     Else
                        GoTo VssCommadExit
                     End If
            End Select
        Case 2
            GoTo VssCommadExit
    End Select
        '============================
    Exit Sub
VssCommadExit:
    執行指令集.執行指令_指令結束標記
    '============================
'=============================
Exit Sub
vss_cmdlocalerr:
執行指令集.執行指令集_錯誤訊息通知 "AtkingGetUsedCards", vbecommadnum(2, vbecommadtotplay), vbecommadnum(4, vbecommadtotplay)
End Sub
Sub 執行指令_傳送訊息(ByVal uscom As Integer, ByVal commadtype As Integer, ByVal atkingnum As Integer)
    If Formsetting.checktest.Value = 0 Then On Error GoTo vss_cmdlocalerr
    commadstr3 = Split(vbecommadstr(3, vbecommadtotplay), ",")
    If UBound(commadstr3) <> 0 Then GoTo VssCommadExit
    Select Case vbecommadnum(2, vbecommadtotplay)
        Case 1
            戰鬥系統類.廣播訊息 commadstr3(0)
            GoTo VssCommadExit
    End Select
    '============================
    Exit Sub
VssCommadExit:
    執行指令集.執行指令_指令結束標記
    '============================
'=============================
Exit Sub
vss_cmdlocalerr:
執行指令集.執行指令集_錯誤訊息通知 "BattleSendMessage", vbecommadnum(2, vbecommadtotplay), vbecommadnum(4, vbecommadtotplay)
End Sub
Sub 執行指令_禁止執行人物主動技及被動技技能(ByVal uscom As Integer, ByVal commadtype As Integer, ByVal atkingnum As Integer)
    If Formsetting.checktest.Value = 0 Then On Error GoTo vss_cmdlocalerr
    commadstr3 = Split(vbecommadstr(3, vbecommadtotplay), ",")
    If UBound(commadstr3) <> 2 Or (commadtype <> 1 And vbecommadnum(4, vbecommadtotplay) <> 61) Or atkingnum <= 8 Then GoTo VssCommadExit
    Select Case vbecommadnum(2, vbecommadtotplay)
        Case 1
            Select Case Val(commadstr3(0))
                 Case 1
                       uscomt = uscom
                 Case 2
                       If uscom = 1 Then uscomt = 2 Else uscomt = 1
            End Select
            '========================================
            Select Case Val(commadstr3(2))
                 Case 1
                       Vss_PersonAtkingOffNum(uscomt, 角色待機人物紀錄數(uscomt, Val(commadstr3(1)))) = 1
                 Case 2
                       Vss_PersonAtkingOffNum(uscomt, 角色待機人物紀錄數(uscomt, Val(commadstr3(1)))) = 0
            End Select
            GoTo VssCommadExit
    End Select
    '============================
    Exit Sub
VssCommadExit:
    執行指令集.執行指令_指令結束標記
    '============================
'=============================
Exit Sub
vss_cmdlocalerr:
執行指令集.執行指令集_錯誤訊息通知 "PersonAtkingOff", vbecommadnum(2, vbecommadtotplay), vbecommadnum(4, vbecommadtotplay)
End Sub
Sub 執行指令_執行之傷害無效化_專(ByVal uscom As Integer, ByVal commadtype As Integer, ByVal atkingnum As Integer)
    If Formsetting.checktest.Value = 0 Then On Error GoTo vss_cmdlocalerr
    commadstr3 = Split(vbecommadstr(3, vbecommadtotplay), ",")
    If UBound(commadstr3) <> 0 Or Val(vbecommadnum(4, vbecommadtotplay)) <> 46 Then GoTo VssCommadExit
    Select Case vbecommadnum(2, vbecommadtotplay)
        Case 1
            Vss_EventBloodActionOffNum = 1
            GoTo VssCommadExit
    End Select
    '============================
    Exit Sub
VssCommadExit:
    執行指令集.執行指令_指令結束標記
    '============================
'=============================
Exit Sub
vss_cmdlocalerr:
執行指令集.執行指令集_錯誤訊息通知 "EventBloodActionOff", vbecommadnum(2, vbecommadtotplay), vbecommadnum(4, vbecommadtotplay)
End Sub
Sub 執行指令_執行之回復無效化_專(ByVal uscom As Integer, ByVal commadtype As Integer, ByVal atkingnum As Integer)
    If Formsetting.checktest.Value = 0 Then On Error GoTo vss_cmdlocalerr
    commadstr3 = Split(vbecommadstr(3, vbecommadtotplay), ",")
    If UBound(commadstr3) <> 0 Or Val(vbecommadnum(4, vbecommadtotplay)) <> 48 Then GoTo VssCommadExit
    Select Case vbecommadnum(2, vbecommadtotplay)
        Case 1
            Vss_EventHPLActionOffNum = 1
            GoTo VssCommadExit
    End Select
    '============================
    Exit Sub
VssCommadExit:
    執行指令集.執行指令_指令結束標記
    '============================
'=============================
Exit Sub
vss_cmdlocalerr:
執行指令集.執行指令集_錯誤訊息通知 "EventHPLActionOff", vbecommadnum(2, vbecommadtotplay), vbecommadnum(4, vbecommadtotplay)
End Sub
Sub 執行指令_異常狀態控制_加入(ByVal uscom As Integer, ByVal commadtype As Integer, ByVal atkingnum As Integer)
    If Formsetting.checktest.Value = 0 Then On Error GoTo vss_cmdlocalerr
    commadstr3 = Split(vbecommadstr(3, vbecommadtotplay), ",")
    If UBound(commadstr3) <> 4 Or (commadtype <> 1 And vbecommadnum(4, vbecommadtotplay) <> 61) Or atkingnum = 9 Then GoTo VssCommadExit
    Dim uscomt As Integer
    Dim vsstr As String
    Select Case vbecommadnum(2, vbecommadtotplay)
        Case 1
            Select Case Val(commadstr3(0))
                 Case 1
                       uscomt = uscom
                 Case 2
                       If uscom = 1 Then uscomt = 2 Else uscomt = 1
            End Select
            If Val(commadstr3(4)) <= 0 Then GoTo vss_cmdlocalerr '==指令參數回合數不正確
            '==========================================
            If ((uscomt = 1 And liveus(角色待機人物紀錄數(uscomt, Val(commadstr3(1)))) <= 0) Or _
               (uscomt = 2 And livecom(角色待機人物紀錄數(uscomt, Val(commadstr3(1)))) <= 0)) Then
               GoTo VssCommadExit
            End If
            '===========================================執行取代既有的異常狀態資料
            For i = 1 To 14
                If 人物異常狀態資料庫(uscomt, 角色待機人物紀錄數(uscomt, Val(commadstr3(1))), i, 3) = commadstr3(2) And Val(人物異常狀態資料庫(uscomt, 角色待機人物紀錄數(uscomt, Val(commadstr3(1))), i, 2)) > 0 Then
                    Select Case uscomt
                        Case 1
'                            FormMainMode.personusspe(i).person_num = Val(commadstr3(3))
'                            FormMainMode.personusspe(i).person_turn = Val(commadstr3(4))
                            FormMainMode.cardus(角色待機人物紀錄數(uscomt, Val(commadstr3(1)))).Buff_異常狀態效果變化量_變更 = Val(commadstr3(3)) & "#" & i
                            FormMainMode.cardus(角色待機人物紀錄數(uscomt, Val(commadstr3(1)))).Buff_異常狀態效果回合數_變更 = Val(commadstr3(4)) & "#" & i
                            人物異常狀態資料庫(uscomt, 角色待機人物紀錄數(uscomt, Val(commadstr3(1))), i, 1) = Val(commadstr3(3))
                            人物異常狀態資料庫(uscomt, 角色待機人物紀錄數(uscomt, Val(commadstr3(1))), i, 2) = Val(commadstr3(4))
                        Case 2
'                            FormMainMode.personcomspe(i).person_num = Val(commadstr3(3))
'                            FormMainMode.personcomspe(i).person_turn = Val(commadstr3(4))
                            FormMainMode.cardcom(角色待機人物紀錄數(uscomt, Val(commadstr3(1)))).Buff_異常狀態效果變化量_變更 = Val(commadstr3(3)) & "#" & i
                            FormMainMode.cardcom(角色待機人物紀錄數(uscomt, Val(commadstr3(1)))).Buff_異常狀態效果回合數_變更 = Val(commadstr3(4)) & "#" & i
                            人物異常狀態資料庫(uscomt, 角色待機人物紀錄數(uscomt, Val(commadstr3(1))), i, 1) = Val(commadstr3(3))
                            人物異常狀態資料庫(uscomt, 角色待機人物紀錄數(uscomt, Val(commadstr3(1))), i, 2) = Val(commadstr3(4))
                    End Select
                    GoTo VssCommadExit
                End If
            Next
            '===========================================新增異常狀態資料
            For k = 1 To UBound(VBEVSSBuffStr1)
                If VBEVSSBuffStr1(k) = commadstr3(2) Then
                    vsstr = FormMainMode.PEAFvssc(k + 54).Run("main", 4)
                    For i = 1 To 14
                        If Val(人物異常狀態資料庫(uscomt, 角色待機人物紀錄數(uscomt, Val(commadstr3(1))), i, 2)) = 0 Then
                            人物異常狀態資料庫(uscomt, 角色待機人物紀錄數(uscomt, Val(commadstr3(1))), i, 4) = App.Path & vsstr
                            戰鬥系統類.人物異常狀態表設定_初設 uscomt, 角色待機人物紀錄數(uscomt, Val(commadstr3(1))), i, commadstr3(2), App.Path & vsstr, Val(commadstr3(3)), Val(commadstr3(4))
                            GoTo VssCommadExit
                        End If
                    Next
                    If i = 15 Then
                        '==============人物已超過14個異常狀態上限
                        戰鬥系統類.廣播訊息 VBEPerson(uscomt, 角色待機人物紀錄數(uscomt, Val(commadstr3(1))), 1, 1, 1) & "  已超過異常狀態之擁有上限，宣告死亡。"
                        Select Case uscomt
                             Case 1
                                   戰鬥系統類.傷害執行_立即死亡_使用者 Val(commadstr3(1))
                             Case 2
                                   戰鬥系統類.傷害執行_立即死亡_電腦 Val(commadstr3(1))
                        End Select
                        '=======================
                    End If
                End If
            Next
            '===============未找到異常狀態資料
            GoTo VssCommadExit
    End Select
    '============================
    Exit Sub
VssCommadExit:
    執行指令集.執行指令_指令結束標記
    '============================
'=============================
Exit Sub
vss_cmdlocalerr:
執行指令集.執行指令集_錯誤訊息通知 "PersonAddBuff", vbecommadnum(2, vbecommadtotplay), vbecommadnum(4, vbecommadtotplay)
End Sub
Sub 執行指令_正面骰數控制(ByVal uscom As Integer, ByVal commadtype As Integer, ByVal atkingnum As Integer)
    If Formsetting.checktest.Value = 0 Then On Error GoTo vss_cmdlocalerr
    commadstr3 = Split(vbecommadstr(3, vbecommadtotplay), ",")
    If UBound(commadstr3) <> 1 Or (vbecommadnum(4, vbecommadtotplay) < 20 And vbecommadnum(4, vbecommadtotplay) > 29) Then GoTo VssCommadExit
    Select Case vbecommadnum(2, vbecommadtotplay)
        Case 1
            Select Case Val(commadstr3(0))
                Case 1
                    擲骰表單溝通暫時變數(2) = 擲骰表單溝通暫時變數(2) + Val(commadstr3(1))
                Case 2
                    擲骰表單溝通暫時變數(2) = 擲骰表單溝通暫時變數(2) - Val(commadstr3(1))
                Case 3
                    擲骰表單溝通暫時變數(2) = Val(commadstr3(1))
            End Select
            GoTo VssCommadExit
    End Select
    '============================
    Exit Sub
VssCommadExit:
    執行指令集.執行指令_指令結束標記
    '============================
'=============================
Exit Sub
vss_cmdlocalerr:
執行指令集.執行指令集_錯誤訊息通知 "AtkingTrueDiceControl", vbecommadnum(2, vbecommadtotplay), vbecommadnum(4, vbecommadtotplay)
End Sub
Sub 執行指令_異常狀態控制_當回合結束_專(ByVal uscom As Integer, ByVal commadtype As Integer, ByVal atkingnum As Integer)
    If Formsetting.checktest.Value = 0 Then On Error GoTo vss_cmdlocalerr
    commadstr3 = Split(vbecommadstr(3, vbecommadtotplay), ",")
    If UBound(commadstr3) <> 0 Or commadtype <> 1 Or atkingnum <> 9 Then GoTo VssCommadExit
    Dim buffvssnum As String
    Dim vsstr As String
    Select Case vbecommadnum(2, vbecommadtotplay)
        Case 1
            buffvssnum = VBEVSSBuffStr1(vbecommadnum(3, vbecommadtotplay) - 54)
            '===========================================執行取代既有的異常狀態資料
            For i = 1 To 14
                If 人物異常狀態資料庫(uscom, vbecommadnum(7, vbecommadtotplay), i, 3) = buffvssnum And Val(人物異常狀態資料庫(uscom, vbecommadnum(7, vbecommadtotplay), i, 2)) > 0 Then
                    人物異常狀態資料庫(uscom, vbecommadnum(7, vbecommadtotplay), i, 2) = Val(人物異常狀態資料庫(uscom, vbecommadnum(7, vbecommadtotplay), i, 2)) - 1
                    Select Case uscom
                        Case 1
'                            FormMainMode.personusspe(i).person_turn = Val(人物異常狀態資料庫(uscom, i, 2))
                            FormMainMode.cardus(vbecommadnum(7, vbecommadtotplay)).Buff_異常狀態效果回合數_變更 = 人物異常狀態資料庫(uscom, vbecommadnum(7, vbecommadtotplay), i, 2) & "#" & i
                        Case 2
'                            FormMainMode.personcomspe(i).person_turn = Val(人物異常狀態資料庫(uscom, i, 2))
                            FormMainMode.cardcom(vbecommadnum(7, vbecommadtotplay)).Buff_異常狀態效果回合數_變更 = 人物異常狀態資料庫(uscom, vbecommadnum(7, vbecommadtotplay), i, 2) & "#" & i
                    End Select
                    GoTo VssCommadExit
                End If
            Next
    End Select
    '============================
    Exit Sub
VssCommadExit:
    執行指令集.執行指令_指令結束標記
    '============================
'=============================
Exit Sub
vss_cmdlocalerr:
執行指令集.執行指令集_錯誤訊息通知 "BuffTurnEnd", vbecommadnum(2, vbecommadtotplay), vbecommadnum(4, vbecommadtotplay)
End Sub
Sub 執行指令_異常狀態控制_全部清除_專(ByVal uscom As Integer, ByVal commadtype As Integer, ByVal atkingnum As Integer)
    If Formsetting.checktest.Value = 0 Then On Error GoTo vss_cmdlocalerr
    commadstr3 = Split(vbecommadstr(3, vbecommadtotplay), ",")
    If UBound(commadstr3) <> 1 Or (commadtype <> 1 And vbecommadnum(4, vbecommadtotplay) <> 61) Or atkingnum = 9 Then GoTo VssCommadExit
    Dim buffvssnum As String
    Dim vsstr As String
    Select Case vbecommadnum(2, vbecommadtotplay)
        Case 1
            Select Case Val(commadstr3(0))
                 Case 1
                       uscomt = uscom
                 Case 2
                       If uscom = 1 Then uscomt = 2 Else uscomt = 1
            End Select
            '===========================================
            If ((uscomt = 1 And liveus(角色待機人物紀錄數(uscomt, Val(commadstr3(1)))) <= 0) Or _
               (uscomt = 2 And livecom(角色待機人物紀錄數(uscomt, Val(commadstr3(1)))) <= 0)) Then
               GoTo VssCommadExit
            End If
            '===========================================
            Select Case uscomt
                Case 1
                    執行動作_清除所有異常狀態_使用者 Val(commadstr3(1))
                Case 2
                    執行動作_清除所有異常狀態_電腦 Val(commadstr3(1))
            End Select
            GoTo VssCommadExit
    End Select
    '============================
    Exit Sub
VssCommadExit:
    執行指令集.執行指令_指令結束標記
    '============================
'=============================
Exit Sub
vss_cmdlocalerr:
執行指令集.執行指令集_錯誤訊息通知 "PersonRemoveBuffAll", vbecommadnum(2, vbecommadtotplay), vbecommadnum(4, vbecommadtotplay)
End Sub
Sub 執行指令_異常狀態控制_特定清除_專(ByVal uscom As Integer, ByVal commadtype As Integer, ByVal atkingnum As Integer)
    If Formsetting.checktest.Value = 0 Then On Error GoTo vss_cmdlocalerr
    commadstr3 = Split(vbecommadstr(3, vbecommadtotplay), ",")
    If UBound(commadstr3) <> 2 Or (commadtype <> 1 And vbecommadnum(4, vbecommadtotplay) <> 61) Or atkingnum = 9 Then GoTo VssCommadExit
    Dim buffvssnum As String
    Dim vsstr As String
    Select Case vbecommadnum(2, vbecommadtotplay)
        Case 1
            Select Case Val(commadstr3(0))
                 Case 1
                       uscomt = uscom
                 Case 2
                       If uscom = 1 Then uscomt = 2 Else uscomt = 1
            End Select
            '===========================================
            If ((uscomt = 1 And liveus(角色待機人物紀錄數(uscomt, Val(commadstr3(1)))) <= 0) Or _
               (uscomt = 2 And livecom(角色待機人物紀錄數(uscomt, Val(commadstr3(1)))) <= 0)) Then
               GoTo VssCommadExit
            End If
            '===========================================
            For i = 1 To 14
                If 人物異常狀態資料庫(uscomt, 角色待機人物紀錄數(uscomt, Val(commadstr3(1))), i, 3) = commadstr3(2) Then
                    執行階段73_指令_異常狀態控制_特定清除 uscomt, Val(commadstr3(1)), i
                    If Vss_EventRemoveBuffActionOffNum = 0 Then
                       人物異常狀態資料庫(uscomt, 角色待機人物紀錄數(uscomt, Val(commadstr3(1))), i, 2) = 0
                    End If
                    Exit For
                End If
            Next
            '=================
            戰鬥系統類.異常狀態繼承_使用者
            戰鬥系統類.異常狀態繼承_電腦
            GoTo VssCommadExit
    End Select
    '============================
    Exit Sub
VssCommadExit:
    執行指令集.執行指令_指令結束標記
    '============================
'=============================
Exit Sub
vss_cmdlocalerr:
執行指令集.執行指令集_錯誤訊息通知 "PersonRemoveBuffSelect", vbecommadnum(2, vbecommadtotplay), vbecommadnum(4, vbecommadtotplay)
End Sub

Sub 執行指令_執行之異常狀態消滅無效化_專(ByVal uscom As Integer, ByVal commadtype As Integer, ByVal atkingnum As Integer)
    If Formsetting.checktest.Value = 0 Then On Error GoTo vss_cmdlocalerr
    commadstr3 = Split(vbecommadstr(3, vbecommadtotplay), ",")
    If UBound(commadstr3) <> 0 Or Val(vbecommadnum(4, vbecommadtotplay)) <> 73 Or atkingnum <> 9 Then GoTo VssCommadExit
    Select Case vbecommadnum(2, vbecommadtotplay)
        Case 1
            Vss_EventRemoveBuffActionOffNum = 1
            GoTo VssCommadExit
    End Select
    '============================
    Exit Sub
VssCommadExit:
    執行指令集.執行指令_指令結束標記
    '============================
'=============================
Exit Sub
vss_cmdlocalerr:
執行指令集.執行指令集_錯誤訊息通知 "EventRemoveBuffActionOff", vbecommadnum(2, vbecommadtotplay), vbecommadnum(4, vbecommadtotplay)
End Sub
Sub 執行指令_擁有之卡牌控制(ByVal uscom As Integer, ByVal commadtype As Integer, ByVal atkingnum As Integer)
    If Formsetting.checktest.Value = 0 Then On Error GoTo vss_cmdlocalerr
    commadstr3 = Split(vbecommadstr(3, vbecommadtotplay), ",")
    If UBound(commadstr3) <> 2 Or (commadtype <> 1 And vbecommadnum(4, vbecommadtotplay) <> 61) Then GoTo VssCommadExit
    Dim uscomt As Integer
    Select Case Val(commadstr3(0))
         Case 1
               uscomt = uscom
         Case 2
               If uscom = 1 Then uscomt = 2 Else uscomt = 1
    End Select
    Select Case vbecommadnum(2, vbecommadtotplay)
        Case 1
            Select Case uscomt
                Case 1
                     Select Case Val(commadstr3(1))
                         Case 1 '==手牌出牌
                             If pagecardnum(Val(commadstr3(2)), 5) = uscomt And pagecardnum(Val(commadstr3(2)), 6) = 1 Then
                                 FormMainMode.card_CardClick (Val(commadstr3(2)))
                             End If
                         Case 2 '==出牌回牌
                             If pagecardnum(Val(commadstr3(2)), 5) = uscomt And pagecardnum(Val(commadstr3(2)), 6) = 2 Then
                                 FormMainMode.card_CardClick (Val(commadstr3(2)))
                             End If
                         Case 3 '==轉牌
                             If pagecardnum(Val(commadstr3(2)), 5) = uscomt And pagecardnum(Val(commadstr3(2)), 6) = 1 Then
                                 FormMainMode.card_CardButtonClickin (Val(commadstr3(2)))
                             ElseIf pagecardnum(Val(commadstr3(2)), 5) = uscomt And pagecardnum(Val(commadstr3(2)), 6) = 2 Then
                                 FormMainMode.card_CardButtonClickout (Val(commadstr3(2)))
                             End If
                    End Select
                Case 2
                    Select Case Val(commadstr3(1))
                         Case 1 '==手牌出牌
                             If pagecardnum(Val(commadstr3(2)), 5) = uscomt And pagecardnum(Val(commadstr3(2)), 6) = 1 Then
                                 戰鬥系統類.電腦牌_模擬按牌 (Val(commadstr3(2)))
                             End If
                         Case 2 '==出牌回牌
                             If pagecardnum(Val(commadstr3(2)), 5) = uscomt And pagecardnum(Val(commadstr3(2)), 6) = 2 Then
                                 戰鬥系統類.電腦牌_模擬按牌_外 (Val(commadstr3(2)))
                             End If
                         Case 3 '==轉牌
                             If pagecardnum(Val(commadstr3(2)), 5) = uscomt And pagecardnum(Val(commadstr3(2)), 6) = 1 Then
                                    Dim cspce As String, cspme As String
                                    cspce = pagecardnum(Val(commadstr3(2)), 1)
                                    cspme = pagecardnum(Val(commadstr3(2)), 2)
                                    pagecardnum(Val(commadstr3(2)), 1) = pagecardnum(Val(commadstr3(2)), 3)
                                    pagecardnum(Val(commadstr3(2)), 2) = pagecardnum(Val(commadstr3(2)), 4)
                                    pagecardnum(Val(commadstr3(2)), 3) = cspce
                                    pagecardnum(Val(commadstr3(2)), 4) = cspme
                                    If pageonin(Val(commadstr3(2))) = 2 Then
                                       pageonin(Val(commadstr3(2))) = 1
                                    Else
                                       pageonin(Val(commadstr3(2))) = 2
                                    End If
                             ElseIf pagecardnum(Val(commadstr3(2)), 5) = uscomt And pagecardnum(Val(commadstr3(2)), 6) = 2 Then
                                 戰鬥系統類.電腦牌_模擬轉牌_外 (Val(commadstr3(2)))
                             End If
                    End Select
            End Select
            GoTo VssCommadExit
    End Select
    '============================
    Exit Sub
VssCommadExit:
    執行指令集.執行指令_指令結束標記
    '============================
'=============================
Exit Sub
vss_cmdlocalerr:
執行指令集.執行指令集_錯誤訊息通知 "AtkingOneSelfCardControl", vbecommadnum(2, vbecommadtotplay), vbecommadnum(4, vbecommadtotplay)
End Sub
Sub 執行指令_執行擲骰子(ByVal uscom As Integer, ByVal commadtype As Integer, ByVal atkingnum As Integer)
    If Formsetting.checktest.Value = 0 Then On Error GoTo vss_cmdlocalerr
    commadstr3 = Split(vbecommadstr(3, vbecommadtotplay), ",")
    If UBound(commadstr3) <> 0 Or (vbecommadnum(4, vbecommadtotplay) <> 13 And vbecommadnum(4, vbecommadtotplay) <> 33) Then GoTo VssCommadExit
    Select Case vbecommadnum(2, vbecommadtotplay)
        Case 1
             擲骰表單溝通暫時變數(2) = 0
             擲骰表單溝通暫時變數(3) = 0
             擲骰表單溝通暫時變數(5) = 0
             擲骰表單溝通暫時變數(6) = 0
             '========================================
            擲骰表單溝通暫時變數(9) = 攻擊防禦骰子總數(1)
            擲骰表單溝通暫時變數(10) = 攻擊防禦骰子總數(2)
            戰鬥系統類.擲骰表單顯示
            目前數(24) = 24
            FormMainMode.等待時間_2.Enabled = True
            vbecommadnum(2, vbecommadtotplay) = 0 '==等待時間
        Case 2
            '=======================
            執行階段系統_宣告開始或結束 1
            '=======================
            Dim VBEStageNumMain(1 To 5) As Integer
            Dim personnum As Integer, persontype As Integer
            Dim buffvssnum As String
            If vbecommadnum(3, vbecommadtotplay - 1) <= 24 Then
                執行階段系統類.執行階段系統總主要程序_人物主動技能 uscom, atkingnum, 62, VBEStageNumMain
            ElseIf vbecommadnum(3, vbecommadtotplay - 1) > 24 And vbecommadnum(3, vbecommadtotplay - 1) <= 48 Then
                If vbecommadnum(3, vbecommadtotplay - 1) - 24 - 12 <= 0 Then
                   personnum = Int((vbecommadnum(3, vbecommadtotplay - 1) - 24) / 4 + 0.9)
                Else
                  personnum = Int((vbecommadnum(3, vbecommadtotplay - 1) - 24 - 12) / 4 + 0.9)
                End If
                If 角色人物對戰人數(uscom, 2) = personnum Then persontype = 1 Else persontype = 2
                '================================
                執行階段系統類.執行階段系統總主要程序_人物被動技能 uscom, personnum, atkingnum, 62, persontype, VBEStageNumMain
            ElseIf vbecommadnum(3, vbecommadtotplay - 1) > 48 And vbecommadnum(3, vbecommadtotplay - 1) <= 54 Then
                If vbecommadnum(3, vbecommadtotplay - 1) - 48 > 3 Then
                    personnum = vbecommadnum(3, vbecommadtotplay - 1) - 48 - 3
                Else
                    personnum = vbecommadnum(3, vbecommadtotplay - 1) - 48
                End If
                If 角色人物對戰人數(uscom, 2) = personnum Then persontype = 1 Else persontype = 2
                '=================================
                執行階段系統類.執行階段系統總主要程序_人物實際狀態 uscom, personnum, 62, persontype, VBEStageNumMain
            Else
                buffvssnum = VBEVSSBuffStr1(vbecommadnum(3, vbecommadtotplay - 1) - 54)
                For i = 1 To 14
                    If 人物異常狀態資料庫(uscom, vbecommadnum(7, vbecommadtotplay - 1), i, 3) = buffvssnum And Val(人物異常狀態資料庫(uscom, vbecommadnum(7, vbecommadtotplay - 1), i, 2)) > 0 Then
                        執行階段系統類.執行階段系統總主要程序_異常狀態 uscom, vbecommadnum(7, vbecommadtotplay - 1), i, 62, vbecommadnum(6, vbecommadtotplay - 1), VBEStageNumMain
                        Exit For
                    End If
                Next
            End If
            '=======================
            執行階段系統_宣告開始或結束 2
            GoTo VssCommadExit
    End Select
    '============================
    Exit Sub
VssCommadExit:
    執行指令集.執行指令_指令結束標記
    '============================
'=============================
Exit Sub
vss_cmdlocalerr:
執行指令集.執行指令集_錯誤訊息通知 "BattleStartDice", vbecommadnum(2, vbecommadtotplay), vbecommadnum(4, vbecommadtotplay)
End Sub
Sub 執行指令_人物最大卡格數控制(ByVal uscom As Integer, ByVal commadtype As Integer, ByVal atkingnum As Integer)
    If Formsetting.checktest.Value = 0 Then On Error GoTo vss_cmdlocalerr
    commadstr3 = Split(vbecommadstr(3, vbecommadtotplay), ",")
    If UBound(commadstr3) <> 2 Or (commadtype <> 1 And vbecommadnum(4, vbecommadtotplay) <> 61) Then GoTo VssCommadExit
    Dim uscomt As Integer
    Select Case Val(commadstr3(0))
         Case 1
               uscomt = uscom
         Case 2
               If uscom = 1 Then uscomt = 2 Else uscomt = 1
    End Select
    Select Case vbecommadnum(2, vbecommadtotplay)
        Case 1
            Select Case uscomt
                Case 1
                    Select Case Val(commadstr3(1))
                        Case 1
                            牌總階段數(1) = 牌總階段數(1) + Val(commadstr3(2))
                        Case 2
                            牌總階段數(1) = 牌總階段數(1) - Val(commadstr3(2))
                    End Select
                Case 2
                    Select Case Val(commadstr3(1))
                        Case 1
                            牌總階段數(2) = 牌總階段數(2) + Val(commadstr3(2))
                        Case 2
                            牌總階段數(2) = 牌總階段數(2) - Val(commadstr3(2))
                    End Select
            End Select
            GoTo VssCommadExit
    End Select
    '============================
    Exit Sub
VssCommadExit:
    執行指令集.執行指令_指令結束標記
    '============================
'=============================
Exit Sub
vss_cmdlocalerr:
執行指令集.執行指令集_錯誤訊息通知 "PersonMaxCardsNumControl", vbecommadnum(2, vbecommadtotplay), vbecommadnum(4, vbecommadtotplay)
End Sub
Sub 執行指令_插入事件卡(ByVal uscom As Integer, ByVal commadtype As Integer, ByVal atkingnum As Integer)
    If Formsetting.checktest.Value = 0 Then On Error GoTo vss_cmdlocalerr
    commadstr3 = Split(vbecommadstr(3, vbecommadtotplay), ",")
    If UBound(commadstr3) <> 2 Or (commadtype <> 1 And vbecommadnum(4, vbecommadtotplay) <> 61) Then GoTo VssCommadExit
    Dim uscomt As Integer
    Select Case vbecommadnum(2, vbecommadtotplay)
        Case 1
            Select Case Val(commadstr3(0))
                 Case 1
                       uscomt = uscom
                 Case 2
                       If uscom = 1 Then uscomt = 2 Else uscomt = 1
            End Select
            '===========================================
            If Val(commadstr3(1)) < 1 Or Val(commadstr3(1)) > 18 Or 一般系統類.事件卡資料庫(commadstr3(2), 1) = 99 Then
                GoTo VssCommadExit
            End If
            For i = 18 To (Val(commadstr3(1)) + 1) Step -1
                 pageeventnum(uscomt, i, 1) = pageeventnum(uscomt, i - 1, 1)
                 pageeventnum(uscomt, i, 2) = pageeventnum(uscomt, i - 1, 2)
            Next
            For i = Val(commadstr3(1)) To Val(commadstr3(1))
                 If 一般系統類.事件卡資料庫(commadstr3(2), 1) <> 99 Then
                    pageeventnum(uscomt, i, 1) = commadstr3(2)
                    pageeventnum(uscomt, i, 2) = 一般系統類.事件卡資料庫(commadstr3(2), 2)
                 End If
            Next
            '===========================================
            GoTo VssCommadExit
    End Select
    '============================
    Exit Sub
VssCommadExit:
    執行指令集.執行指令_指令結束標記
    '============================
'=============================
Exit Sub
vss_cmdlocalerr:
執行指令集.執行指令集_錯誤訊息通知 "BattleInsertEventCard", vbecommadnum(2, vbecommadtotplay), vbecommadnum(4, vbecommadtotplay)
End Sub
Sub 執行指令_人物實際狀態控制_加入(ByVal uscom As Integer, ByVal commadtype As Integer, ByVal atkingnum As Integer)
    If Formsetting.checktest.Value = 0 Then On Error GoTo vss_cmdlocalerr
    commadstr3 = Split(vbecommadstr(3, vbecommadtotplay), ",")
    If UBound(commadstr3) <> 3 Or (commadtype <> 1 And vbecommadnum(4, vbecommadtotplay) <> 61) Or atkingnum >= 9 Then GoTo VssCommadExit
    Dim uscomt As Integer, persontype As Integer
    Dim vsstr As String, textlinea As String, str As String
    Select Case Val(commadstr3(0))
         Case 1
               uscomt = uscom
         Case 2
               If uscom = 1 Then uscomt = 2 Else uscomt = 1
    End Select
    Select Case vbecommadnum(2, vbecommadtotplay)
        Case 1
            If Val(commadstr3(3)) <= 0 Then GoTo vss_cmdlocalerr '==指令參數回合數不正確
            '===========================================清空既有的人物實際狀態資料
            If 人物實際狀態資料庫(uscomt, 角色待機人物紀錄數(uscomt, Val(commadstr3(1))), 1) <> "" Then
                For k = 1 To 9
                     人物實際狀態資料庫(uscomt, 角色待機人物紀錄數(uscomt, Val(commadstr3(1))), k) = ""
                Next
            End If
            '===========================================新增人物實際狀態資料
            For k = 1 To UBound(VBEVSSActualStatusStr1)
                If VBEVSSActualStatusStr1(k) = commadstr3(2) Then
                    Open VBEVSSActualStatusStr2(k) For Input As #1
                    Do Until EOF(1)
                       Line Input #1, textlinea
                       str = str & textlinea & vbCrLf
                    Loop
                    Close
                    If str <> "" Then
                        FormMainMode.PEAFvssc((uscomt - 1) * 3 + 角色待機人物紀錄數(uscomt, Val(commadstr3(1))) + 48).AddCode str
                    End If
                    vsstr = FormMainMode.PEAFvssc((uscomt - 1) * 3 + 角色待機人物紀錄數(uscomt, Val(commadstr3(1))) + 48).Run("main", 1)
                    If vsstr = commadstr3(2) Then
                        人物實際狀態資料庫(uscomt, 角色待機人物紀錄數(uscomt, Val(commadstr3(1))), 1) = commadstr3(2)
                        人物實際狀態資料庫(uscomt, 角色待機人物紀錄數(uscomt, Val(commadstr3(1))), 9) = FormMainMode.PEAFvssc((uscomt - 1) * 3 + 角色待機人物紀錄數(uscomt, Val(commadstr3(1))) + 48).Run("main", 3)
                        vbecommadnum(2, vbecommadtotplay) = 2
                        Exit Sub
                    End If
                End If
            Next
            '===============未找到符合之人物實際狀態腳本資料
            GoTo VssCommadExit
        Case 2
            '=======================
            執行階段系統_宣告開始或結束 1
            '=======================
            Dim VBEStageNumMain(1 To 5) As Integer
            VBEStageNumMain(1) = Val(commadstr3(3))
            If Val(commadstr3(1)) > 1 Then persontype = 2 Else persontype = 1
            執行階段系統類.執行階段系統總主要程序_人物實際狀態 uscomt, 角色待機人物紀錄數(uscomt, Val(commadstr3(1))), 74, persontype, VBEStageNumMain
            '=======================
            執行階段系統_宣告開始或結束 2
            GoTo VssCommadExit
    End Select
    '============================
    Exit Sub
VssCommadExit:
    執行指令集.執行指令_指令結束標記
    '============================
'=============================
Exit Sub
vss_cmdlocalerr:
執行指令集.執行指令集_錯誤訊息通知 "PersonAddActualStatus", vbecommadnum(2, vbecommadtotplay), vbecommadnum(4, vbecommadtotplay)
End Sub
Sub 執行指令_人物實際狀態加入資料_專(ByVal uscom As Integer, ByVal commadtype As Integer, ByVal atkingnum As Integer)
    If Formsetting.checktest.Value = 0 Then On Error GoTo vss_cmdlocalerr
    commadstr3 = Split(vbecommadstr(3, vbecommadtotplay), ",")
    Dim personnum As Integer, i As Integer, p As Integer
    Dim strfalse As Boolean
    If UBound(commadstr3) = 7 And ( _
        (commadtype = 1 And (vbecommadnum(4, vbecommadtotplay) <> 13 Or vbecommadnum(4, vbecommadtotplay) <> 33)) _
        Or Val(vbecommadnum(4, vbecommadtotplay)) = 61 _
        Or Val(vbecommadnum(4, vbecommadtotplay)) = 41 _
        Or (Val(vbecommadnum(4, vbecommadtotplay)) >= 46 And Val(vbecommadnum(4, vbecommadtotplay)) <= 48) _
        Or Val(vbecommadnum(4, vbecommadtotplay)) = 74) _
        And atkingnum = 10 Then
        '==以上為正確之條件
    Else
        GoTo VssCommadExit
    End If
    If vbecommadnum(3, vbecommadtotplay) - 48 > 3 Then
        personnum = vbecommadnum(3, vbecommadtotplay) - 48 - 3
    Else
        personnum = vbecommadnum(3, vbecommadtotplay) - 48
    End If
    '==========
    Select Case vbecommadnum(2, vbecommadtotplay)
        Case 1
            For i = 3 To 6
                If commadstr3(i - 3) = "" Then
                    strfalse = True
                Else
                    人物實際狀態資料庫(uscom, personnum, i) = App.Path & commadstr3(i - 3)
                End If
            Next
            p = (uscom - 1) * 2 + 4
            For i = 7 To 8
                 人物實際狀態資料庫(uscom, personnum, i) = Val(commadstr3(p))
                 p = p + 1
            Next
            If strfalse = False Then 人物實際狀態資料庫(uscom, personnum, 2) = 1 Else 人物實際狀態資料庫(uscom, personnum, 2) = 0
            '===================
            If 角色人物對戰人數(uscom, 2) = personnum And 人物實際狀態資料庫(uscom, personnum, 2) = 1 Then
                Select Case uscom
                    Case 1
                        FormMainMode.personusminijpg.小人物消失 = True
                    Case 2
                        FormMainMode.personcomminijpg.小人物消失 = True
                End Select
                vbecommadnum(2, vbecommadtotplay) = 2
            Else
                GoTo VssCommadExit
            End If
            '===================
        Case 2
            If FormMainMode.personusminijpg.小人物消失 = False And FormMainMode.personcomminijpg.小人物消失 = False Then
                '==================
                Select Case uscom
                    Case 1
                        FormMainMode.personusminijpg.小人物圖片 = 人物實際狀態資料庫(uscom, personnum, 4)
                        FormMainMode.personusminijpg.小人物影子圖片 = 人物實際狀態資料庫(uscom, personnum, 5)
                        FormMainMode.顯示列1.使用者方小人物圖片 = 人物實際狀態資料庫(uscom, personnum, 6)
                        FormMainMode.personusminijpg.小人物影子Left = Val(人物實際狀態資料庫(uscom, personnum, 7))
                        FormMainMode.personusminijpg.小人物影子top差 = Val(人物實際狀態資料庫(uscom, personnum, 8))
                        戰鬥擲骰介面人物立繪圖路徑紀錄數(1) = 人物實際狀態資料庫(uscom, personnum, 3)
                        FormMainMode.顯示列1.使用者方小人物圖片left = -(FormMainMode.顯示列1.使用者方小人物圖片width)
                        戰鬥系統類.執行動作_距離變更 movecp
                        FormMainMode.personusminijpg.小人物顯現 = True
                    Case 2
                        FormMainMode.personcomminijpg.小人物圖片 = 人物實際狀態資料庫(uscom, personnum, 4)
                        FormMainMode.personcomminijpg.小人物影子圖片 = 人物實際狀態資料庫(uscom, personnum, 5)
                        FormMainMode.顯示列1.電腦方小人物圖片 = 人物實際狀態資料庫(uscom, personnum, 6)
                        FormMainMode.personcomminijpg.小人物影子Left = Val(人物實際狀態資料庫(uscom, personnum, 7))
                        FormMainMode.personcomminijpg.小人物影子top差 = Val(人物實際狀態資料庫(uscom, personnum, 8))
                        戰鬥擲骰介面人物立繪圖路徑紀錄數(2) = 人物實際狀態資料庫(uscom, personnum, 3)
                        FormMainMode.顯示列1.電腦方小人物圖片left = FormMainMode.ScaleWidth
                        戰鬥系統類.執行動作_距離變更 movecp
                        FormMainMode.personcomminijpg.小人物顯現 = True
                End Select
                vbecommadnum(2, vbecommadtotplay) = 3
                '==================
            End If
        Case 3
            If FormMainMode.personusminijpg.小人物顯現 = False And FormMainMode.personcomminijpg.小人物顯現 = False Then
                GoTo VssCommadExit
            End If
    End Select
    '============================
    Exit Sub
VssCommadExit:
    執行指令集.執行指令_指令結束標記
    '============================
'=============================
Exit Sub
vss_cmdlocalerr:
執行指令集.執行指令集_錯誤訊息通知 "EventAddActualStatusData", vbecommadnum(2, vbecommadtotplay), vbecommadnum(4, vbecommadtotplay)
End Sub
Sub 執行指令_人物實際狀態控制_宣告結束_專(ByVal uscom As Integer, ByVal commadtype As Integer, ByVal atkingnum As Integer)
    If Formsetting.checktest.Value = 0 Then On Error GoTo vss_cmdlocalerr
    commadstr3 = Split(vbecommadstr(3, vbecommadtotplay), ",")
    If UBound(commadstr3) <> 0 Or commadtype <> 1 Or atkingnum <> 10 Then GoTo VssCommadExit
    Dim personnum As Integer, i As Integer
    Dim vsstr As String
    If vbecommadnum(3, vbecommadtotplay) - 48 > 3 Then
        personnum = vbecommadnum(3, vbecommadtotplay) - 48 - 3
    Else
        personnum = vbecommadnum(3, vbecommadtotplay) - 48
    End If
    '===========
    Select Case vbecommadnum(2, vbecommadtotplay)
        Case 1
            If 角色人物對戰人數(uscom, 2) = personnum Then
                Select Case uscom
                    Case 1
                        FormMainMode.personusminijpg.小人物消失 = True
                    Case 2
                        FormMainMode.personcomminijpg.小人物消失 = True
                End Select
                vbecommadnum(2, vbecommadtotplay) = 2
            Else
                vbecommadnum(2, vbecommadtotplay) = 3
            End If
        Case 2
            If FormMainMode.personusminijpg.小人物消失 = False And FormMainMode.personcomminijpg.小人物消失 = False Then
                '==================
                Select Case uscom
                    Case 1
                        FormMainMode.personusminijpg.小人物圖片 = VBEPerson(1, 角色人物對戰人數(1, 2), 1, 5, 1)
                        FormMainMode.personusminijpg.小人物影子圖片 = VBEPerson(1, 角色人物對戰人數(1, 2), 1, 5, 2)
                        FormMainMode.顯示列1.使用者方小人物圖片 = VBEPerson(1, 角色人物對戰人數(1, 2), 1, 5, 4)
                        FormMainMode.personusminijpg.小人物影子Left = Val(VBEPerson(1, 角色人物對戰人數(1, 2), 2, 1, 5))
                        FormMainMode.personusminijpg.小人物影子top差 = Val(VBEPerson(1, 角色人物對戰人數(1, 2), 2, 1, 6))
                        戰鬥擲骰介面人物立繪圖路徑紀錄數(1) = VBEPerson(1, 角色人物對戰人數(1, 2), 1, 5, 3)
                        FormMainMode.顯示列1.使用者方小人物圖片left = -(FormMainMode.顯示列1.使用者方小人物圖片width)
                        戰鬥系統類.執行動作_距離變更 movecp
                        FormMainMode.personusminijpg.小人物顯現 = True
                    Case 2
                        FormMainMode.personcomminijpg.小人物圖片 = VBEPerson(2, 角色人物對戰人數(2, 2), 1, 5, 1)
                        FormMainMode.personcomminijpg.小人物影子圖片 = VBEPerson(2, 角色人物對戰人數(2, 2), 1, 5, 2)
                        FormMainMode.顯示列1.電腦方小人物圖片 = VBEPerson(2, 角色人物對戰人數(2, 2), 1, 5, 4)
                        FormMainMode.personcomminijpg.小人物影子Left = VBEPerson(2, 角色人物對戰人數(2, 2), 2, 1, 5)
                        FormMainMode.personcomminijpg.小人物影子top差 = VBEPerson(2, 角色人物對戰人數(2, 2), 2, 1, 6)
                        戰鬥擲骰介面人物立繪圖路徑紀錄數(2) = VBEPerson(2, 角色人物對戰人數(2, 2), 1, 5, 3)
                        FormMainMode.顯示列1.電腦方小人物圖片left = FormMainMode.ScaleWidth
                        戰鬥系統類.執行動作_距離變更 movecp
                        FormMainMode.personcomminijpg.小人物顯現 = True
                End Select
                vbecommadnum(2, vbecommadtotplay) = 3
                '==================
            End If
        Case 3
            If FormMainMode.personusminijpg.小人物顯現 = False And FormMainMode.personcomminijpg.小人物顯現 = False Then
                For i = 1 To UBound(人物實際狀態資料庫, 3)
                     人物實際狀態資料庫(uscom, personnum, i) = ""
                Next
                FormMainMode.PEAFvssc(vbecommadnum(3, vbecommadtotplay)).Reset
                GoTo VssCommadExit
            End If
    End Select
    '============================
    Exit Sub
VssCommadExit:
    執行指令集.執行指令_指令結束標記
    '============================
'=============================
Exit Sub
vss_cmdlocalerr:
執行指令集.執行指令集_錯誤訊息通知 "ActualStatusEnd", vbecommadnum(2, vbecommadtotplay), vbecommadnum(4, vbecommadtotplay)
End Sub
Sub 執行指令_人物實際狀態控制_特定解除_專(ByVal uscom As Integer, ByVal commadtype As Integer, ByVal atkingnum As Integer)
    If Formsetting.checktest.Value = 0 Then On Error GoTo vss_cmdlocalerr
    commadstr3 = Split(vbecommadstr(3, vbecommadtotplay), ",")
    If UBound(commadstr3) <> 1 Or (commadtype <> 1 And vbecommadnum(4, vbecommadtotplay) <> 61) Or atkingnum >= 9 Then GoTo VssCommadExit
    Dim buffvssnum As String
    Dim vsstr As String
    Select Case Val(commadstr3(0))
         Case 1
               uscomt = uscom
         Case 2
               If uscom = 1 Then uscomt = 2 Else uscomt = 1
    End Select
    Select Case vbecommadnum(2, vbecommadtotplay)
        Case 1
            If 人物實際狀態資料庫(uscomt, 角色待機人物紀錄數(uscomt, Val(commadstr3(1))), 1) <> "" Then
                Vss_EventRemoveActualStatusActionOffNum = 0
                '=======================
                執行階段系統_宣告開始或結束 1
                '=======================
                Dim VBEStageNumMain(1 To 5) As Integer
                If Val(commadstr3(1)) > 1 Then persontype = 2 Else persontype = 1
                執行階段系統類.執行階段系統總主要程序_人物實際狀態 uscomt, 角色待機人物紀錄數(uscomt, Val(commadstr3(1))), 75, persontype, VBEStageNumMain
                '=======================
                執行階段系統_宣告開始或結束 2
                '=======================
                vbecommadnum(2, vbecommadtotplay) = 2
            Else
                GoTo VssCommadExit
            End If
            '=================
        Case 2
            If Vss_EventRemoveActualStatusActionOffNum = 1 Then
                If Val(commadstr3(1)) = 1 Then
                    Select Case uscomt
                        Case 1
                            FormMainMode.personusminijpg.小人物消失 = True
                        Case 2
                            FormMainMode.personcomminijpg.小人物消失 = True
                    End Select
                    vbecommadnum(2, vbecommadtotplay) = 3
                Else
                    vbecommadnum(2, vbecommadtotplay) = 4
                End If
            Else
                GoTo VssCommadExit
            End If
        Case 3
            If FormMainMode.personusminijpg.小人物消失 = False And FormMainMode.personcomminijpg.小人物消失 = False Then
                '==================
                Select Case uscomt
                    Case 1
                        FormMainMode.personusminijpg.小人物圖片 = VBEPerson(1, 角色人物對戰人數(1, 2), 1, 5, 1)
                        FormMainMode.personusminijpg.小人物影子圖片 = VBEPerson(1, 角色人物對戰人數(1, 2), 1, 5, 2)
                        FormMainMode.顯示列1.使用者方小人物圖片 = VBEPerson(1, 角色人物對戰人數(1, 2), 1, 5, 4)
                        FormMainMode.personusminijpg.小人物影子Left = Val(VBEPerson(1, 角色人物對戰人數(1, 2), 2, 1, 5))
                        FormMainMode.personusminijpg.小人物影子top差 = Val(VBEPerson(1, 角色人物對戰人數(1, 2), 2, 1, 6))
                        戰鬥擲骰介面人物立繪圖路徑紀錄數(1) = VBEPerson(1, 角色人物對戰人數(1, 2), 1, 5, 3)
                        FormMainMode.顯示列1.使用者方小人物圖片left = -(FormMainMode.顯示列1.使用者方小人物圖片width)
                        戰鬥系統類.執行動作_距離變更 movecp
                        FormMainMode.personusminijpg.小人物顯現 = True
                    Case 2
                        FormMainMode.personcomminijpg.小人物圖片 = VBEPerson(2, 角色人物對戰人數(2, 2), 1, 5, 1)
                        FormMainMode.personcomminijpg.小人物影子圖片 = VBEPerson(2, 角色人物對戰人數(2, 2), 1, 5, 2)
                        FormMainMode.顯示列1.電腦方小人物圖片 = VBEPerson(2, 角色人物對戰人數(2, 2), 1, 5, 4)
                        FormMainMode.personcomminijpg.小人物影子Left = VBEPerson(2, 角色人物對戰人數(2, 2), 2, 1, 5)
                        FormMainMode.personcomminijpg.小人物影子top差 = VBEPerson(2, 角色人物對戰人數(2, 2), 2, 1, 6)
                        戰鬥擲骰介面人物立繪圖路徑紀錄數(2) = VBEPerson(2, 角色人物對戰人數(2, 2), 1, 5, 3)
                        FormMainMode.顯示列1.電腦方小人物圖片left = FormMainMode.ScaleWidth
                        戰鬥系統類.執行動作_距離變更 movecp
                        FormMainMode.personcomminijpg.小人物顯現 = True
                End Select
                vbecommadnum(2, vbecommadtotplay) = 4
                '==================
            End If
        Case 4
            If FormMainMode.personusminijpg.小人物顯現 = False And FormMainMode.personcomminijpg.小人物顯現 = False Then
                For i = 1 To UBound(人物實際狀態資料庫, 3)
                     人物實際狀態資料庫(uscomt, 角色待機人物紀錄數(uscomt, Val(commadstr3(1))), i) = ""
                Next
                FormMainMode.PEAFvssc((uscomt - 1) * 3 + 角色待機人物紀錄數(uscomt, Val(commadstr3(1))) + 48).Reset
                GoTo VssCommadExit
            End If
    End Select
    '============================
    Exit Sub
VssCommadExit:
    執行指令集.執行指令_指令結束標記
    '============================
'=============================
Exit Sub
vss_cmdlocalerr:
執行指令集.執行指令集_錯誤訊息通知 "PersonRemoveActualStatus", vbecommadnum(2, vbecommadtotplay), vbecommadnum(4, vbecommadtotplay)
End Sub
Sub 執行指令_執行之人物實際狀態消滅無效化_專(ByVal uscom As Integer, ByVal commadtype As Integer, ByVal atkingnum As Integer)
    If Formsetting.checktest.Value = 0 Then On Error GoTo vss_cmdlocalerr
    commadstr3 = Split(vbecommadstr(3, vbecommadtotplay), ",")
    If UBound(commadstr3) <> 0 Or Val(vbecommadnum(4, vbecommadtotplay)) <> 75 Or atkingnum <> 10 Then GoTo VssCommadExit
    Select Case vbecommadnum(2, vbecommadtotplay)
        Case 1
            Vss_EventRemoveActualStatusActionOffNum = 1
            GoTo VssCommadExit
    End Select
    '============================
    Exit Sub
VssCommadExit:
    執行指令集.執行指令_指令結束標記
    '============================
'=============================
Exit Sub
vss_cmdlocalerr:
執行指令集.執行指令集_錯誤訊息通知 "EventRemoveActualStatusActionOff", vbecommadnum(2, vbecommadtotplay), vbecommadnum(4, vbecommadtotplay)
End Sub
Sub 執行指令_智慧型AI個別技能評分(ByVal uscom As Integer, ByVal commadtype As Integer, ByVal atkingnum As Integer)
    If Formsetting.checktest.Value = 0 Then On Error GoTo vss_cmdlocalerr
    commadstr3 = Split(vbecommadstr(3, vbecommadtotplay), ",")
    If UBound(commadstr3) < 1 Or vbecommadnum(3, vbecommadtotplay) > 24 Or Val(vbecommadnum(4, vbecommadtotplay)) <> 99 Then GoTo VssCommadExit
    Select Case vbecommadnum(2, vbecommadtotplay)
        Case 1
            ReDim Vss_EventActiveAIScoreNum(1 To UBound(commadstr3) + 1) As Integer
            For i = 0 To UBound(commadstr3)
                Vss_EventActiveAIScoreNum(i + 1) = commadstr3(i)
            Next
            '=====================
            GoTo VssCommadExit
    End Select
        '============================
    Exit Sub
VssCommadExit:
    執行指令集.執行指令_指令結束標記
    '============================
'=============================
Exit Sub
vss_cmdlocalerr:
執行指令集.執行指令集_錯誤訊息通知 "EventActiveAIScore", vbecommadnum(2, vbecommadtotplay), vbecommadnum(4, vbecommadtotplay)
End Sub
Sub 執行指令_移動前總移動量控制(ByVal uscom As Integer, ByVal commadtype As Integer, ByVal atkingnum As Integer)
    If Formsetting.checktest.Value = 0 Then On Error GoTo vss_cmdlocalerr
    commadstr3 = Split(vbecommadstr(3, vbecommadtotplay), ",")
    If UBound(commadstr3) <> 2 Or (commadtype <> 1 And vbecommadnum(4, vbecommadtotplay) <> 61) Then GoTo VssCommadExit
    Dim uscomt As Integer
    Select Case Val(commadstr3(0))
         Case 1
               uscomt = uscom
         Case 2
               If uscom = 1 Then uscomt = 2 Else uscomt = 1
    End Select
    Select Case vbecommadnum(2, vbecommadtotplay)
        Case 1
            Select Case commadstr3(1)
                Case 1
                     If Vss_PersonMoveControlNum(uscomt, 2) = 0 Then
                        Vss_PersonMoveControlNum(uscomt, 1) = Vss_PersonMoveControlNum(uscomt, 1) + Val(commadstr3(2))
                     End If
                Case 2
                     If Vss_PersonMoveControlNum(uscomt, 2) = 0 Then
                        Vss_PersonMoveControlNum(uscomt, 1) = Vss_PersonMoveControlNum(uscomt, 1) - Val(commadstr3(2))
                     End If
                Case 3
                     Vss_PersonMoveControlNum(uscomt, 1) = Val(commadstr3(2))
                     Vss_PersonMoveControlNum(uscomt, 2) = 1
            End Select
            GoTo VssCommadExit
    End Select
        '============================
    Exit Sub
VssCommadExit:
    執行指令集.執行指令_指令結束標記
    '============================
'=============================
Exit Sub
vss_cmdlocalerr:
執行指令集.執行指令集_錯誤訊息通知 "PersonMoveControl", vbecommadnum(2, vbecommadtotplay), vbecommadnum(4, vbecommadtotplay)
End Sub
Sub 執行指令_技能註記備註字串(ByVal uscom As Integer, ByVal commadtype As Integer, ByVal atkingnum As Integer)
    If Formsetting.checktest.Value = 0 Then On Error GoTo vss_cmdlocalerr
    commadstr3 = Split(vbecommadstr(3, vbecommadtotplay), ",")
    If UBound(commadstr3) <> 0 Or vbecommadnum(3, vbecommadtotplay) > 48 Then GoTo VssCommadExit
    Select Case vbecommadnum(2, vbecommadtotplay)
        Case 1
            Select Case vbecommadnum(3, vbecommadtotplay)
                Case Is <= 24 '==主動技
                        Vss_AtkingInformationRecordStr(uscom, vbecommadnum(7, vbecommadtotplay), atkingnum) = commadstr3(0)
                Case Is <= 48 '==被動技
                        Vss_AtkingInformationRecordStr(uscom, vbecommadnum(7, vbecommadtotplay), atkingnum) = commadstr3(0)
            End Select
            GoTo VssCommadExit
    End Select
        '============================
    Exit Sub
VssCommadExit:
    執行指令集.執行指令_指令結束標記
    '============================
'=============================
Exit Sub
vss_cmdlocalerr:
執行指令集.執行指令集_錯誤訊息通知 "AtkingInformationRecord", vbecommadnum(2, vbecommadtotplay), vbecommadnum(4, vbecommadtotplay)
End Sub

Sub 執行指令_指令結束標記()
    vbecommadnum(1, vbecommadtotplay) = vbecommadnum(1, vbecommadtotplay) + 1
'    執行指令集.執行指令集總程序_指令呼叫執行
End Sub
Sub 執行指令集_錯誤訊息通知(ByVal name As String, ByVal cmdturn As Integer, ByVal systurn As Integer)
MsgBox "執行階段錯誤(04-" & systurn & "-" & name & "-" & cmdturn & ")：" & Chr(10) & "指令於執行時發生錯誤。" & Chr(10) & Chr(10) & "(" & Err.Number & "):" & Err.Description, vbCritical
End
End Sub
Function 執行指令集_執行驗證(ByVal uscom As Integer, ByVal commadtype As Integer, ByVal atkingnum As Integer) As Boolean
If vbecommadnum(3, vbecommadtotplay) <= 48 Then  '==僅主動技能/被動技能需進行啟動驗證
    Select Case vbecommadnum(3, vbecommadtotplay)
         Case Is <= 24
             If atkingck(uscom, 角色人物對戰人數(uscom, 2), atkingnum, 1) = 1 Then
                 執行指令集_執行驗證 = True
             Else
                 執行指令集_執行驗證 = False
             End If
         Case Is <= 48
             Dim vspassivenum As Integer
             If vbecommadnum(3, vbecommadtotplay) - 24 - 12 <= 0 Then
                vspassivenum = Int((vbecommadnum(3, vbecommadtotplay) - 24) / 4 + 0.9)
             Else
               vspassivenum = Int((vbecommadnum(3, vbecommadtotplay) - 24 - 12) / 4 + 0.9)
             End If
             '====================
             If atkingck(uscom, vspassivenum, atkingnum, 1) = 1 Then
                 執行指令集_執行驗證 = True
             Else
                 執行指令集_執行驗證 = False
             End If
    End Select
Else
    執行指令集_執行驗證 = True
End If
End Function
