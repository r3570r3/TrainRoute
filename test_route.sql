create table trainroutes
(
    route_id number(18) PRIMARY KEY,
    train_id number(18),
    from_station_id number(18),
    to_station_id number(18),
    arrival_time timestamp,
    departure_time timestamp
);

create table trains
(
    train_id number(18) PRIMARY KEY,
    train_name varchar(30)
);

create table stations
(
    station_id number(18) PRIMARY KEY,
    station_name varchar(30)
);

alter table trainroutes add constraint fk_train_id foreign key (train_id) references trains(train_id);
alter table trainroutes add constraint fk_from_station_id foreign key (from_station_id) references stations(station_id);
alter table trainroutes add constraint fk_to_station_id foreign key (to_station_id) references stations(station_id);

insert into trains VALUES(1, 'Rajdhani');
insert into trains VALUES(2, 'Falaknuma');
insert into trains VALUES(3, 'East Coast');
insert into trains VALUES(4, 'Shalimar');
insert into trains VALUES(5, 'Intercity');
insert into trains VALUES(6, 'Jammu Tawi');
insert into trains VALUES(7, 'Mughalsarai');
insert into trains VALUES(8, 'Shatabdi');
insert into trains VALUES(9, 'Gareeb Rath');
insert into trains VALUES(10, 'Palace on Wheels');



insert into stations VALUES(1, 'Sealdah');
insert into stations VALUES(2, 'Howrah');
insert into stations VALUES(3, 'Madhupur');
insert into stations VALUES(4, 'Kharagpur');
insert into stations VALUES(5, 'Varanasi');
insert into stations VALUES(6, 'Raniganj');
insert into stations VALUES(7, 'Jammu');
insert into stations VALUES(8, 'Asansol');


insert into trainroutes VALUES(1, 1, 1, 2, sysdate - 2 - 19/20, sysdate - 2 - 18/20);
insert into trainroutes VALUES(2, 1, 2, 3, sysdate - 2 - 17/20, sysdate - 2 - 16/20);
insert into trainroutes VALUES(3, 1, 3, 4, sysdate - 2 - 13/20, sysdate - 2 - 11/20);
insert into trainroutes VALUES(4, 1, 4, 7, sysdate - 2 - 9/20, sysdate - 2 - 8/20);
insert into trainroutes VALUES(5, 1, 7, 8, sysdate - 2 - 3/20, sysdate - 2 - 1/20);

insert into trainroutes VALUES(6, 2, 1, 3, sysdate - 2 - 18/20, sysdate - 2 - 17/20);
insert into trainroutes VALUES(7, 2, 3, 5, sysdate - 2 - 16/20, sysdate - 2 - 15/20);
insert into trainroutes VALUES(8, 2, 5, 4, sysdate - 2 - 12/20, sysdate - 2 - 10/20);
insert into trainroutes VALUES(9, 2, 4, 7, sysdate - 2 - 8/20, sysdate - 2 - 7/20);

insert into trainroutes VALUES(10, 3, 2, 5, sysdate - 2 - 17/20, sysdate - 2 - 16/20);
insert into trainroutes VALUES(11, 3, 5, 3, sysdate - 2 - 15/20, sysdate - 2 - 14/20);
insert into trainroutes VALUES(12, 3, 3, 8, sysdate - 2 - 13/20, sysdate - 2 - 12/20);
insert into trainroutes VALUES(13, 3, 8, 4, sysdate - 2 - 11/20, sysdate - 2 - 10/20);
insert into trainroutes VALUES(14, 3, 4, 7, sysdate - 2 - 9/20, sysdate - 2 - 8/20);



select 
route_result.route_id,
train_data.train_name,
route_result.from_station,
route_result.to_station,
route_result.train_path,
route_result.path_depth
from
(
select route_id, train_id, from_station_id,station_data_1.station_name from_station,to_station_id,station_data_2.station_name to_station,level path_depth, SYS_CONNECT_BY_PATH(station_data_1.station_name, '/') train_path
from trainroutes, stations station_data_1, stations station_data_2
where station_data_1.station_id = trainroutes.FROM_STATION_ID and station_data_2.station_id = trainroutes.to_station_id
start with to_STATION_ID = (select station_id from stations where station_name = 'Jammu')
connect by nocycle prior from_STATION_ID = to_STATION_ID and prior train_id = train_id
) route_result,
trains train_data
where
route_result.train_id = train_data.train_id;
