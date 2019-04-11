DROP TABLE IF EXISTS public.users CASCADE;
DROP TABLE IF EXISTS job_request CASCADE;
DROP TABLE IF EXISTS job_offer CASCADE;
DROP TABLE IF EXISTS request_bids CASCADE;
DROP TABLE IF EXISTS offer_bids CASCADE;
DROP TABLE IF EXISTS request_in_progress CASCADE;
DROP TABLE IF EXISTS offer_in_progress CASCADE;
DROP TABLE IF EXISTS request_completed CASCADE;
DROP TABLE IF EXISTS offer_completed CASCADE;
DROP TABLE IF EXISTS premium_users CASCADE;
drop function if exists checkOfferBidUserValid();
drop function if exists checkRequestBidUserValid();

drop trigger if exists bidRequestTrigger ON request_bids;
drop trigger if exists bidOfferTrigger on offer_bids;

DROP FUNCTION IF EXISTS deleteRequestIP();
DROP TRIGGER IF EXISTS deleteRequestIP ON request_completed;
DROP FUNCTION IF EXISTS deleteOfferIP();
DROP TRIGGER IF EXISTS deleteOfferIP ON offer_completed;

DROP FUNCTION IF EXISTS offer_bid_accepted_func();
DROP TRIGGER IF EXISTS offer_bid_accepted_trigger ON offer_in_progress;
DROP FUNCTION IF EXISTS request_bid_accepted_func();
DROP TRIGGER IF EXISTS request_bid_accepted_trigger ON request_in_progress;

CREATE TABLE public.users (
	"username" CHAR(64),
	"email" CHAR(128),
	"password" CHAR(60),
	"is_admin" BOOLEAN DEFAULT FALSE CHECK(is_admin IN (TRUE, FALSE)),
	CONSTRAINT users_pkey PRIMARY KEY (username)
);

CREATE TABLE job_request (
	"job" CHAR(64),
	"loc" CHAR(128),
	"date" DATE,
	"time" TIME,
	"details" CHAR(128),
	"username" CHAR (64) references public.users(username),
	"job_id" int generated by default as identity primary key
);

-- table of premium users
CREATE TABLE premium_users(
	"username" CHAR(64) references public.users(username),
	PRIMARY KEY (username)
);


CREATE TABLE request_bids(
	"job_id" int references job_request(job_id) ON DELETE CASCADE,
	"bid_user" char(64) references public.users(username),
	"bid_price" int,
	"bid_info" char(1000),
	"bid_id" int generated by default as identity primary key
);

CREATE TABLE job_offer (
	"job" CHAR(64),
	"loc" CHAR(128),
	"date" DATE,
	"time" TIME,
	"details" CHAR(128),
	"username" CHAR (64) references public.users(username),
	"job_id" int generated by default as identity primary key
);

CREATE TABLE offer_bids(
	"job_id" int references job_offer(job_id) ON DELETE CASCADE,
	"bid_user" char(64) references public.users(username),
	"bid_price" int,
	"bid_info" char(1000),
	"bid_id" int generated by default as identity primary key
);

-- relation set between job req and request bids
CREATE TABLE request_in_progress(
	"job_id" int references job_request(job_id) ON DELETE CASCADE,
	"bid_id" int references request_bids(bid_id) ON DELETE CASCADE,
	primary key (job_id, bid_id)
);

-- relation set between job offer and offer bids
CREATE TABLE offer_in_progress(
	"job_id" int references job_offer(job_id) ON DELETE CASCADE,
	"bid_id" int references offer_bids(bid_id) ON DELETE CASCADE,
	primary key (job_id, bid_id)
);

-- relation set between job req and completed
CREATE TABLE request_completed(
	"job_id" int references job_request(job_id) ON DELETE CASCADE,
	"bid_id" int references request_bids(bid_id) ON DELETE CASCADE,
		"author_review"  char(1000) default null,
	"author_rating" int default null,
	"bidder_review"  char(1000) default null,
	"bidder_rating" int default null,
	primary key (job_id, bid_id)
);

-- relation set between job offer and completed
CREATE TABLE offer_completed(
	"job_id" int references job_offer(job_id) ON DELETE CASCADE,
	"bid_id" int references offer_bids(bid_id) ON DELETE CASCADE,
		"author_review"  char(1000) default null,
	"author_rating" int default null,
	"bidder_review"  char(1000) default null,
	"bidder_rating" int default null,

	primary key (job_id, bid_id)
);


CREATE FUNCTION deleteRequestIP()
RETURNS TRIGGER AS $$
BEGIN
	DELETE FROM request_in_progress	
	WHERE job_id=NEW.job_id;
	RETURN NEW; 
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER deleteRequestIP
AFTER INSERT ON request_completed
FOR EACH ROW
EXECUTE PROCEDURE deleteRequestIP();

CREATE FUNCTION deleteOfferIP()
RETURNS TRIGGER AS $$
BEGIN
	DELETE FROM offer_in_progress 
	WHERE job_id=NEW.job_id;
	RETURN NEW; 
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER deleteOfferIP
AFTER INSERT ON offer_completed
FOR EACH ROW
EXECUTE PROCEDURE deleteOfferIP();

INSERT INTO public.users (username, email, password)
VALUES ('dummy1','dummy1@yahoo.com','$2b$10$99cAtaDvYXFAJCMOqGavCuML5dCdlDYZoAEYfwVXu/ASZpKiAGPnS');
INSERT INTO public.users (username, email, password)
VALUES ('dummy2','dummy2@yahoo.com','$2b$10$99cAtaDvYXFAJCMOqGavCuDrC4GADX0PaHFJ8M08gTnAsBiE2LCwW');
INSERT INTO public.users (username, email, password)
VALUES ('d1','d1@d.com','$2b$10$Ou8cxsjo/m5tLOWIaXemtu8fdCWc/gjKRQxQeEn2xSS0Vq6x.RVu2');
INSERT INTO public.users (username, email, password)
VALUES ('d2','d2@d.com','$2b$10$Ou8cxsjo/m5tLOWIaXemtu9VpzH09heAebhxKAp5c8kPnJ5ulFSTW');
INSERT INTO public.users (username, email, password)
VALUES ('d3','d3@d.com','$2b$10$Ou8cxsjo/m5tLOWIaXemtu0JXiq52DXyEHzAR465mFOPiJyKO.PJa');
INSERT INTO public.users (username, email, password)
VALUES ('d4','d4@d.com','$2b$10$Ou8cxsjo/m5tLOWIaXemtu0fbe4TdOMlTAzSazUwXVlN95vQLhRZO');
INSERT INTO public.users (username, email, password, is_admin)
VALUES ('admin1','admin1@gmail.com','$2b$10$.7uMTpD.7SqrerAsb.jJgOr2N60rbUXlE/OO91wESn0KPbPWlRY3S', TRUE);
INSERT INTO public.users (username, email, password)
VALUES('p1','p1@p.com','$2b$10$wCGVdKumqUCwBkmj77xxGeLUJQZPzd2wRNj4fd4aSiI9nNA6HD3VS');
INSERT INTO public.users (username, email, password)
VALUES('p2','p2@p.com','$2b$10$SegFfQ16EJvwCj.x9HGs1OC.jFwZcEZubtlJbq4.aUylDHBO66V1a');

INSERT INTO job_request ("job", "loc", "date", "time", "details","username") 
VALUES ('Babysitting', 'AMK', '2019-08-13', '05:30', 'Look after 4yo','dummy1');
INSERT INTO job_request ("job", "loc", "date", "time", "details","username") 
VALUES ('Gardening', 'TPY', '2019-08-15', '08:30', 'Rebuild my backyard','dummy2');
INSERT INTO job_request ("job", "loc", "date", "time", "details","username") 
VALUES ('Cooking', 'JE', '2019-08-25', '18:30', 'Cook dinner for family of 5','dummy1');
INSERT INTO job_request ("job", "loc", "date", "time", "details","username") 
VALUES ('Delivery', 'KR', '2019-12-01', '12:30', 'Deliver parcel from Changi to Kent Ridge','dummy1');
INSERT INTO job_request ("job", "loc", "date", "time", "details","username") 
VALUES ('Food Delivery', 'KR', '2019-12-01', '18:30', 'Deliver food from Atlas Cafe to NUS','dummy1');

INSERT INTO premium_users ("username")
VALUES ('p1');
INSERT INTO premium_users ("username")
VALUES ('p2');

--job_id 1
INSERT INTO job_offer ("job", "loc", "date", "time", "details","username") 
VALUES ('Assemble Furniture', 'AMK', '2019-08-05', '16:30', 'Help to assemble IKEA book shelf','dummy1');
INSERT INTO job_offer ("job", "loc", "date", "time", "details","username") 
VALUES ('Drive', 'CMW', '2019-08-19', '08:30', 'Drive me to Changi Airport','dummy1');
INSERT INTO job_offer ("job", "loc", "date", "time", "details","username") 
VALUES ('Babysitting', 'BG', '2019-08-25', '19:00', 'Look after my 3yo','dummy2');
INSERT INTO job_offer ("job", "loc", "date", "time", "details","username") 
VALUES ('Delivery', 'KR', '2019-12-01', '12:30', 'Deliver parcel from Jurong East to Kent Ridge','dummy2');
INSERT INTO job_offer ("job", "loc", "date", "time", "details","username") 
VALUES ('Delivery', 'KR', '2019-12-01', '12:30', 'Deliver parcel from Jurong East to Kent Ridge','d1');
INSERT INTO job_offer ("job", "loc", "date", "time", "details","username") 
VALUES ('Delivery', 'KR', '2019-12-01', '12:30', 'Deliver parcel from Jurong East to Kent Ridge','d1');
INSERT INTO job_offer ("job", "loc", "date", "time", "details","username") 
VALUES ('Delivery', 'KR', '2019-12-01', '12:30', 'Deliver parcel from Jurong East to Kent Ridge','d2');
--job_id 8 (below)
INSERT INTO job_offer ("job", "loc", "date", "time", "details","username") 
VALUES ('Delivery', 'KR', '2019-12-01', '12:30', 'Give you food','d2');
INSERT INTO job_offer ("job", "loc", "date", "time", "details","username") 
VALUES ('Delivery', 'KR', '2019-12-01', '12:30', 'Give you durian','d2');
INSERT INTO job_offer ("job", "loc", "date", "time", "details","username") 
VALUES ('Delivery', 'KR', '2019-12-01', '12:30', 'Deliver parcel from Jurong East to Kent Ridge','d3');
INSERT INTO job_offer ("job", "loc", "date", "time", "details","username") 
VALUES ('Delivery', 'KR', '2019-12-01', '12:30', 'Eat with you','d3');
INSERT INTO job_offer ("job", "loc", "date", "time", "details","username") 
VALUES ('Delivery', 'KR', '2019-12-01', '12:30', 'Deliver some fruits','d3');
INSERT INTO job_offer ("job", "loc", "date", "time", "details","username") 
VALUES ('Delivery', 'KR', '2019-12-01', '12:30', 'Deliver parcel from Jurong East to Kent Ridge','d4');


--bid_id 1
insert into request_bids values ('1','dummy2','1','tested bid');

--job_request > request_bid > request_completed sets
--job_id 6
INSERT INTO job_request ("job", "loc", "date", "time", "details","username") 
VALUES ('Feeding', 'AMK', '2019-08-13', '05:30', 'feed me pls','d1');
--bid_id 2
INSERT INTO request_bids ("job_id", "bid_user", "bid_price", "bid_info")
VALUES ('6', 'd2', '20', 'feed you anyday');
INSERT INTO request_completed ("job_id", "bid_id")
VALUES ('6', '2');

--job_id 7
INSERT INTO job_request ("job", "loc", "date", "time", "details","username") 
VALUES ('Feed Kids', 'BSH', '2019-07-15', '05:30', 'im hungryy','d1');
--bid_id 3
INSERT INTO request_bids ("job_id", "bid_user", "bid_price", "bid_info")
VALUES ('7', 'd3', '15', 'im hungryyyy too but ill feed you');
INSERT INTO request_completed ("job_id", "bid_id")
VALUES ('7', '3');

--offer_bids > offer_completed (the job_offer is already specified above)
--bid_id 1
INSERT INTO offer_bids ("job_id", "bid_user", "bid_price", "bid_info")
VALUES ('8', 'd1', '15', 'me want food real bad');
INSERT INTO offer_completed ("job_id", "bid_id")
VALUES ('8', '1');

--bid_id 2
INSERT INTO offer_bids ("job_id", "bid_user", "bid_price", "bid_info")
VALUES ('9', 'd1', '15', 'I need and want food real bad');
INSERT INTO offer_completed ("job_id", "bid_id")
VALUES ('9', '2');

--bid_id 3
INSERT INTO offer_bids ("job_id", "bid_user", "bid_price", "bid_info")
VALUES ('12', 'd1', '15', 'me want food real bad');
INSERT INTO offer_completed ("job_id", "bid_id")
VALUES ('12', '3');

--test values for trigger testing
--job id 14
INSERT INTO job_offer ("job", "loc", "date", "time", "details","username") 
VALUES ('Delivery', 'KR', '2019-12-01', '12:30', 'bid for me plz','d4');
--bid id 4, 5, 6, 7
INSERT INTO offer_bids ("job_id", "bid_user", "bid_price", "bid_info")
VALUES ('14', 'd1', '15', 'me want food real bad');
INSERT INTO offer_bids ("job_id", "bid_user", "bid_price", "bid_info")
VALUES ('14', 'd2', '20', 'me am d2 mad hungz');
INSERT INTO offer_bids ("job_id", "bid_user", "bid_price", "bid_info")
VALUES ('14', 'd3', '100', 'me am d3 soooo hungz');
INSERT INTO offer_bids ("job_id", "bid_user", "bid_price", "bid_info")
VALUES ('13', 'd1', '12', 'me am d1 soooo hungz');

--job_id 8
INSERT INTO job_request ("job", "loc", "date", "time", "details","username") 
VALUES ('Feed Kids', 'BSH', '2019-05-15', '12:30', 'im hungryy','d1');
--bid_id 4
INSERT INTO request_bids ("job_id", "bid_user", "bid_price", "bid_info")
VALUES ('8', 'd4', '22', 'im lovely too but ill feed you with makan');
INSERT INTO request_completed ("job_id", "bid_id")
VALUES ('8', '4');

--job_id 15 (below)
INSERT INTO job_offer ("job", "loc", "date", "time", "details","username") 
VALUES ('Delivery', 'TH', '2019-12-01', '12:30', 'Deliver parcel from Bugis to Temasek Hall','p1');
INSERT INTO job_offer ("job", "loc", "date", "time", "details","username") 
VALUES ('Delivery', 'TH', '2019-12-01', '12:30', 'Date with you','p2');
INSERT INTO job_offer ("job", "loc", "date", "time", "details","username") 
VALUES ('Delivery', 'TH', '2019-12-01', '12:30', 'Deliver some durians','p1');
INSERT INTO job_offer ("job", "loc", "date", "time", "details","username") 
VALUES ('Delivery', 'TH', '2019-12-01', '12:30', 'Deliver parcel from Pioneer to Kent Ridge','p2');
--job_id 9 (below, request)
INSERT INTO job_request ("job", "loc", "date", "time", "details", "username") 
VALUES ('Assemble Furniture', 'TH', '2019-12-01', '12:30', 'Fix lights','p1');
INSERT INTO job_request ("job", "loc", "date", "time", "details", "username") 
VALUES ('Assemble Furniture', 'TH', '2019-12-01', '12:30', 'Dismantle fan','p2');
INSERT INTO job_request ("job", "loc", "date", "time", "details", "username") 
VALUES ('Assemble Furniture', 'TH', '2019-12-01', '12:30', 'Move cabinet','p1');
INSERT INTO job_request ("job", "loc", "date", "time", "details", "username") 
VALUES ('Assemble Furniture', 'TH', '2019-12-01', '12:30', 'Replace floor tiles','p2');

--TRIGGER for job offers. Trigger will fire when a job offer is accepted: i.e.
--when a row is inserted into offer_in_progress. Trigger will cause unaccepted
--bids to be deleted.
CREATE OR REPLACE FUNCTION offer_bid_accepted_func()
RETURNS TRIGGER AS $$
BEGIN
	DELETE FROM offer_bids ob 
	WHERE ob.job_id = NEW.job_id
	AND ob.bid_id != NEW.bid_id;
	RAISE NOTICE 'new job id = %, new bid id = %', NEW.job_id, NEW.bid_id;
	RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER offer_bid_accepted_trigger
AFTER INSERT ON offer_in_progress
FOR EACH ROW
EXECUTE PROCEDURE offer_bid_accepted_func();

--TRIGGER for job requests. Trigger will fire when a job request is accepted:
--ie when a row is inserted into offer_in_progress. Trigger will cause unaccepted
--bids to be deleted. 
CREATE OR REPLACE FUNCTION request_bid_accepted_func()
RETURNS TRIGGER AS $$
BEGIN
	DELETE FROM request_bids rb 
	WHERE rb.job_id = NEW.job_id
	AND rb.bid_id != NEW.bid_id;
	RAISE NOTICE 'new job id = %, new bid id = %', NEW.job_id, NEW.bid_id;
	RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER request_bid_accepted_trigger
AFTER INSERT ON request_in_progress
FOR EACH ROW
EXECUTE PROCEDURE request_bid_accepted_func();


CREATE FUNCTION checkRequestBidUserValid()
RETURNS TRIGGER AS $$
declare
	jobUserName char(64);
begin
	jobUserName := (select username from job_request where job_request.username = new.bid_user and job_request.job_id = new.job_id);
	if new.bid_user = jobUsername then
		raise exception 'Cant bid for your own job';
	end if;
	return new;
RETURN NEW; END;
$$ LANGUAGE plpgsql;

CREATE FUNCTION checkOfferBidUserValid()
RETURNS TRIGGER AS $$
declare
	jobUserName char(64);
begin
	jobUserName := (select username from job_offer where job_offer.username = new.bid_user and job_offer.job_id = new.job_id);
	if new.bid_user = jobUsername then
		raise exception 'Cant bid for your own jobs';
	end if;
	return new;
RETURN NEW; END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER bidRequestTrigger BEFORE insert or update
ON request_bids
FOR EACH ROW EXECUTE PROCEDURE checkRequestBidUserValid();

CREATE TRIGGER bidOfferTrigger BEFORE insert or update
ON offer_bids
FOR EACH ROW EXECUTE PROCEDURE checkOfferBidUserValid(); 


