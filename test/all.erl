%%% -------------------------------------------------------------------
%%% @author  : Joq Erlang
%%% @doc: : 
%%% Created :
%%% Node end point  
%%% Creates and deletes Pods
%%% 
%%% API-kube: Interface 
%%% Pod consits beams from all services, app and app and sup erl.
%%% The setup of envs is
%%% -------------------------------------------------------------------
-module(all).      
 
-export([start/0]).
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------


-define(MainLogDir,"logs").
-define(LocalLogDir,"to_be_changed.logs").
-define(LogFile,"logfile").
-define(MaxNumFiles,10).
-define(MaxNumBytes,100000).


-define(InfraSpecId,"basic"). 


%% --------------------------------------------------------------------
%% Function: available_hosts()
%% Description: Based on hosts.config file checks which hosts are avaible
%% Returns: List({HostId,Ip,SshPort,Uid,Pwd}
%% --------------------------------------------------------------------
start()->
   
    ok=setup(),
    ok=test1(),
    ok=test2(),
    ok=test_tradfri_control_outlet(), 
    ok=test_tradfri_bulb_e27_cws_806lm(),
    ok=test_lumi_weather(),
    ok=test_tradfri_bulb_E14_ws_candleopal_470lm(),
   
    io:format("Test OK !!! ~p~n",[?MODULE]),
    timer:sleep(2000),
%    init:stop(),
    ok.

%% --------------------------------------------------------------------
%% Function: available_hosts()
%% Description: Based on hosts.config file checks which hosts are avaible
%% Returns: List({HostId,Ip,SshPort,Uid,Pwd}
%% --------------------------------------------------------------------
test1()->
    io:format("Start ~p~n",[{?MODULE,?FUNCTION_NAME}]),
    AllDevices=zigbee_devices:all(),
    io:format("AllDevices ~p~n",[{AllDevices,?MODULE,?FUNCTION_NAME}]),    

    ok.
%% --------------------------------------------------------------------
%% Function: available_hosts()
%% Description: Based on hosts.config file checks which hosts are avaible
%% Returns: List({HostId,Ip,SshPort,Uid,Pwd}
%% --------------------------------------------------------------------
test2()->
    io:format("Start ~p~n",[{?MODULE,?FUNCTION_NAME}]),
    AllMaps=zigbee_devices:all_raw(),
    io:format("AllMaps ~p~n",[{AllMaps,?MODULE,?FUNCTION_NAME}]),    

    ok.
%% --------------------------------------------------------------------
%% Function: available_hosts()
%% Description: Based on hosts.config file checks which hosts are avaible
%% Returns: List({HostId,Ip,SshPort,Uid,Pwd}
%% --------------------------------------------------------------------
test_tradfri_bulb_e27_cws_806lm()->
    io:format("Start ~p~n",[{?MODULE,?FUNCTION_NAME}]),
    
    {200,_,_}=zigbee_devices:call("lamp_1",turn_on,[]),
    timer:sleep(200),
    true=zigbee_devices:call("lamp_1",is_reachable,[]),
    false=zigbee_devices:call("lamp_1",is_off,[]),
    true=zigbee_devices:call("lamp_1",is_on,[]),

    {200,_,_}={200,_,_}=zigbee_devices:call("lamp_1",turn_off,[]),
    timer:sleep(200),   
   
    true=zigbee_devices:call("lamp_1",is_off,[]),
    false=zigbee_devices:call("lamp_1",is_on,[]),
   

    ok.
%% --------------------------------------------------------------------
%% Function: available_hosts()
%% Description: Based on hosts.config file checks which hosts are avaible
%% Returns: List({HostId,Ip,SshPort,Uid,Pwd}
%% --------------------------------------------------------------------
test_tradfri_bulb_E14_ws_candleopal_470lm()->
    io:format("Start ~p~n",[{?MODULE,?FUNCTION_NAME}]),
  
    true=zigbee_devices:call("hall_7_8",is_reachable,[]),

    case zigbee_devices:call("hall_7_8",is_on,[]) of
	false->
	    InitState=off,
	    {200,_,_}=zigbee_devices:call("hall_7_8",turn_on,[]);
	true->
	    InitState=on
    end,
   % timer:sleep(200),
    true=zigbee_devices:call("hall_7_8",is_reachable,[]),
    false=zigbee_devices:call("hall_7_8",is_off,[]),
    true=zigbee_devices:call("hall_7_8",is_on,[]),
    InitBri=zigbee_devices:call("hall_7_8",get_bri,[]),
    
    io:format("InitBri ~p~n",[{InitBri,?MODULE,?LINE}]),
    
    TestBri=InitBri+10,
    {200,_,_}=zigbee_devices:call("hall_7_8",set_bri,[TestBri]),
    TestBri=zigbee_devices:call("hall_7_8",get_bri,[]),
    timer:sleep(200),
    {200,_,_}=zigbee_devices:call("hall_7_8",turn_off,[]),
    true=zigbee_devices:call("hall_7_8",is_off,[]),
    false=zigbee_devices:call("hall_7_8",is_on,[]),

    case InitState of
	on->
	    {200,_,_}=zigbee_devices:call("hall_7_8",turn_on,[]),
	    {200,_,_}=zigbee_devices:call("hall_7_8",set_bri,[InitBri]),
	    true=zigbee_devices:call("hall_7_8",is_on,[]),
	    InitBri=zigbee_devices:call("hall_7_8",get_bri,[]);
	off->
	    {200,_,_}=zigbee_devices:call("hall_7_8",turn_on,[]),
	    {200,_,_}=zigbee_devices:call("hall_7_8",set_bri,[InitBri]),
	    true=zigbee_devices:call("hall_7_8",is_on,[]),
	    InitBri=zigbee_devices:call("hall_7_8",get_bri,[]),
	    {200,_,_}=zigbee_devices:call("hall_7_8",turn_off,[]),
	    false=zigbee_devices:call("hall_7_8",is_on,[])
    end,
    ok.
%% --------------------------------------------------------------------
%% Function: available_hosts()
%% Description: Based on hosts.config file checks which hosts are avaible
%% Returns: List({HostId,Ip,SshPort,Uid,Pwd}
%% --------------------------------------------------------------------
test_tradfri_control_outlet()->
    io:format("Start ~p~n",[{?MODULE,?FUNCTION_NAME}]),

    {200,_,_}=zigbee_devices:call("outlet_1",turn_on,[]),
    timer:sleep(200),
    true=zigbee_devices:call("outlet_1",is_reachable,[]),
    false=zigbee_devices:call("outlet_1",is_off,[]),
    true=zigbee_devices:call("outlet_1",is_on,[]),

    {200,_,_}={200,_,_}=zigbee_devices:call("outlet_1",turn_off,[]),
    timer:sleep(2000),
    true=zigbee_devices:call("outlet_1",is_off,[]),
    false=zigbee_devices:call("outlet_1",is_on,[]),

    
    ok.
%% --------------------------------------------------------------------
%% Function: available_hosts()
%% Description: Based on hosts.config file checks which hosts are avaible
%% Returns: List({HostId,Ip,SshPort,Uid,Pwd}
%% --------------------------------------------------------------------
test_lumi_weather()->
    io:format("Start ~p~n",[{?MODULE,?FUNCTION_NAME}]),


    true=zigbee_devices:call("weather_1",is_reachable,[]),

   
    Temp=zigbee_devices:call("weather_1",temp,[]),
    io:format("Temp ~p~n",[{Temp,?MODULE,?LINE}]),
    Humidity=zigbee_devices:call("weather_1",humidity,[]),
    io:format("Humidity ~p~n",[{Humidity,?MODULE,?LINE}]),
    Pressure=zigbee_devices:call("weather_1",pressure,[]),
    io:format("Pressure ~p~n",[{Pressure,?MODULE,?LINE}]),
    
    ok.

    
%% --------------------------------------------------------------------
%% Function: available_hosts()
%% Description: Based on hosts.config file checks which hosts are avaible
%% Returns: List({HostId,Ip,SshPort,Uid,Pwd}
%% --------------------------------------------------------------------


setup()->
    io:format("Start ~p~n",[{?MODULE,?FUNCTION_NAME}]),

    file:del_dir_r(?MainLogDir),
    ok=application:start(log),
    pong=log:ping(),
    LocalLogDir=atom_to_list(node())++".logs",
    ok=log:create_logger(?MainLogDir,LocalLogDir,?LogFile,?MaxNumFiles,?MaxNumBytes),
    
    ok=application:start(rd),
    pong=rd:ping(),
    ok=application:start(etcd),
    pong=etcd:ping(),
    
    %% connect to control_nodes
    ThisNode=node(),
    {ok,ConnecNodes}=etcd_infra:get_connect_nodes(?InfraSpecId),
    ConnectR=[{net_adm:ping(N),N}||N<-ConnecNodes],
    io:format("ConnectR ~p~n",[{ConnectR,?MODULE,?FUNCTION_NAME}]),

      ok=application:start(zigbee_devices),
    pong=zigbee_devices:ping(),
    
    ok.
