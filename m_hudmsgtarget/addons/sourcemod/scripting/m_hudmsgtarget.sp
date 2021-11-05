#include <sourcemod>
#include <sdktools>
#include <multicolors>

#pragma newdecls required
#pragma semicolon 1
#define DEBUG

#define m_Exec "hudmsgtarget_mandoxx"
#define m_PLUGIN_NAME "HUD message to target"
#define m_PLUGIN_AUTHOR "mandoxx"
#define m_PLUGIN_VERSION "1.0"
#define m_PLUGIN_DP "HUD MSG"
#define m_PLUGIN_URL "steamcommunity.com/id/mandoxxdev"

#define m_Fx 0.45 //////////////////////////////////////////////////////////////////////////////////////////////////////////////
#define m_Fy 0.25 ///////////////////////////////////// Hud ////////////////////////////////////////////////////////////////////
#define m_Time 10.0 ////////////////////////////////////////////////////////////////////////////////////////////////////////////
#define m_R 255 //////////////////////////////////////////////////////////////////////////////////////////////////////////////
#define m_G 0	//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#define m_A 255	///////////////////////////////////// colors /////////////////////////////////////////////////////////////////
#define m_E 1	//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#define m_B 127 //////////////////////////////////////////////////////////////////////////////////////////////////////////////
ConVar m_dxEnabled;
ConVar m_dxFlag;
ConVar m_dxMsgYourself;
ConVar m_dxonecommandpround;
ConVar m_dxAllPlayers;
bool m_commandpround[MAXPLAYERS + 1] = {false, ...};

public Plugin myinfo = 
{
	name = m_PLUGIN_NAME,
	author = m_PLUGIN_AUTHOR,
	description = m_PLUGIN_DP,
	version = m_PLUGIN_VERSION,
	url = m_PLUGIN_URL
};

#define m_ChatPrefix "SM" // change your prefix here

public void OnPluginStart()
{
	m_dxEnabled = CreateConVar("m_dxEnabled", "1", "Enable = 1 // Disable = 0");
	m_dxFlag = CreateConVar("m_dxFlag", "o", "AdminFlags");
	m_dxMsgYourself = CreateConVar("m_dxMsgYourself", "0", "Do not allow to send message to yourself [Enable = 1 // Disable = 0]");
	m_dxonecommandpround = CreateConVar("m_dxonecommandpround", "1", "Allows you to use the command only once per round [Enable = 1 // Disable = 0]");
	m_dxAllPlayers = CreateConVar("m_dxAllPlayers", "1", "allows all players to use the command [Enable = 1 // Disable = 0]");
	AutoExecConfig(true, m_Exec);
	RegConsoleCmd("sm_msg", msg_mand);
	RegConsoleCmd("sm_message", msg_mand);
	RegConsoleCmd("sm_mensagem", msg_mand);
	HookEvent("round_start", roundStart);
}

public Action msg_mand(int client, int args)
{	
	char m_Arg1[32], m_Arg2[32];
	GetCmdArg(1, m_Arg1, sizeof(m_Arg1));
	GetCmdArgString(m_Arg2, sizeof(m_Arg2));
	int m_target = FindTarget(client, m_Arg1);
	if (m_target == -1)
	return Plugin_Handled;
		
	if(m_commandpround[client]) 
{
	CPrintToChat(client, "[%s] Wait until the round is over to use it again", m_ChatPrefix);
	return Plugin_Handled;	
}
	if(m_dxonecommandpround.IntValue == 1)
{
	m_commandpround[client] = true;
}
	
	if(m_dxAllPlayers.IntValue == 1)
{
	SetHudTextParams(m_Fx, m_Fy, m_Time, m_R, m_G, m_B, m_A, m_E);
	CPrintToChat(client, "[%s] You sent %s to %N", m_ChatPrefix, m_Arg2, m_target);
	ShowHudText(m_target, -1, "%s", m_Arg2);
	return Plugin_Handled;
}
	if(m_dxEnabled.IntValue == 0)
{
	CPrintToChat(client, "[%s] plugin is disabled", m_ChatPrefix);
	return Plugin_Handled;
}
	if(m_dxMsgYourself.IntValue == 1)
{
	if(m_target == client) 
{
	CPrintToChat(client, "[%s] You cannot send a message to yourself", m_ChatPrefix);
	return Plugin_Handled;	
}
}
	if (!m_IsPlayerFlag(client))
{
	CPrintToChat(client, "[%s] You do not have access to this command", m_ChatPrefix);
	return Plugin_Handled;
}
	if(args < 2) 
{
	CReplyToCommand(client, "[%s] Use: sm_msg [name|#userid] [message]", m_ChatPrefix);
	return Plugin_Handled;	
}
	if(m_dxEnabled.IntValue == 1)
{
	SetHudTextParams(m_Fx, m_Fy, m_Time, m_R, m_G, m_B, m_A, m_E);
	CPrintToChat(client, "[%s] You sent %s to %N", m_ChatPrefix, m_Arg2, m_target);
	ShowHudText(m_target, -1, "%s", m_Arg2);

}
	return Plugin_Handled;
}

stock bool m_IsPlayerFlag(int client)
{
	char flag[10];
	m_dxFlag.GetString(flag, sizeof(flag));
	
	if (GetUserFlagBits(client) & ReadFlagString(flag) || GetAdminFlag(GetUserAdmin(client), Admin_Root))
	return true;
	return false;
}

public void roundStart(Handle event, const char[]name, bool dontBroadcast)
{
	for (int client = 1; client <= MaxClients; client++)
		m_commandpround[client] = false;
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////fuck<3
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////king<3
////////////////////////////////////////////////////////////////////////////////////////////////////////////////amaze<3