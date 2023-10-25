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
    ok=test_tradfri_bulb_e27_cws_806lm(),
    ok=test_tradfri_control_outlet(),
    ok=test_lumi_weather(),
   
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
   {200,_,_}=tradfri_bulb_e27_cws_806lm:turn_on("lamp_1"),
    timer:sleep(200),
    true=tradfri_bulb_e27_cws_806lm:is_reachable("lamp_1"),
    false=tradfri_bulb_e27_cws_806lm:is_off("lamp_1"),
    true=tradfri_bulb_e27_cws_806lm:is_on("lamp_1"),

    {200,_,_}=tradfri_bulb_e27_cws_806lm:turn_off("lamp_1"),
    timer:sleep(2000),
    true=tradfri_bulb_e27_cws_806lm:is_off("lamp_1"),
    false=tradfri_bulb_e27_cws_806lm:is_on("lamp_1"),
    
    

    

    ok.
%% --------------------------------------------------------------------
%% Function: available_hosts()
%% Description: Based on hosts.config file checks which hosts are avaible
%% Returns: List({HostId,Ip,SshPort,Uid,Pwd}
%% --------------------------------------------------------------------
test_tradfri_control_outlet()->
    io:format("Start ~p~n",[{?MODULE,?FUNCTION_NAME}]),

   {200,_,_}=tradfri_control_outlet:turn_on("outlet_1"),
    timer:sleep(200),
    true=tradfri_control_outlet:is_reachable("outlet_1"),
    false=tradfri_control_outlet:is_off("outlet_1"),
    true=tradfri_control_outlet:is_on("outlet_1"),

    {200,_,_}=tradfri_control_outlet:turn_off("outlet_1"),
    timer:sleep(2000),
    true=tradfri_control_outlet:is_off("outlet_1"),
    false=tradfri_control_outlet:is_on("outlet_1"),
    
    ok.
%% --------------------------------------------------------------------
%% Function: available_hosts()
%% Description: Based on hosts.config file checks which hosts are avaible
%% Returns: List({HostId,Ip,SshPort,Uid,Pwd}
%% --------------------------------------------------------------------
test_lumi_weather()->
    io:format("Start ~p~n",[{?MODULE,?FUNCTION_NAME}]),

    true=lumi_weather:is_reachable("weather_1"),
    Temp=lumi_weather:temp("weather_1"),
    io:format("Temp ~p~n",[{Temp,?MODULE,?LINE}]),
    Humidity=lumi_weather:humidity("weather_1"),
    io:format("Humidity ~p~n",[{Humidity,?MODULE,?LINE}]),
    Pressure=lumi_weather:pressure("weather_1"),
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
