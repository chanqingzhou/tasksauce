DROP TABLE IF EXISTS public.users CASCADE;
DROP TABLE IF EXISTS job_request CASCADE;
DROP TABLE IF EXISTS job_offer CASCADE;

CREATE TABLE public.users (
	"username" CHAR(64),
	"email" CHAR(128),
	"password" CHAR(60),
	CONSTRAINT users_pkey PRIMARY KEY (username)
);

CREATE TABLE job_request (
	"job" CHAR(64),
	"loc" CHAR(128),
	"date" DATE,
	"time" TIME,
	"desc" CHAR(128),
	"job_id" int generated by default as identity primary key
);

CREATE TABLE job_offer (
	"job" CHAR(64),
	"loc" CHAR(128),
	"date" DATE,
	"time" TIME,
	"desc" CHAR(128),
	"job_id" int generated by default as identity primary key
);

INSERT INTO public.users (username, email, password)
VALUES ('dummy1','dummy1@yahoo.com','$2b$10$99cAtaDvYXFAJCMOqGavCuML5dCdlDYZoAEYfwVXu/ASZpKiAGPnS');
 INSERT INTO public.users (username, email, password)
VALUES ('dummy2','dummy2@yahoo.com','$2b$10$99cAtaDvYXFAJCMOqGavCuDrC4GADX0PaHFJ8M08gTnAsBiE2LCwW');

INSERT INTO job_request ("job", "loc", "date", "time", "desc") 
VALUES ('Babysitting', 'AMK', '2019-08-13', '05:30', 'Look after 4yo');
INSERT INTO job_request ("job", "loc", "date", "time", "desc") 
VALUES ('Gardening', 'TPY', '2019-08-15', '08:30', 'Rebuild my backyard');
INSERT INTO job_request ("job", "loc", "date", "time", "desc") 
VALUES ('Cooking', 'JE', '2019-08-25', '18:30', 'Cook dinner for family of 5');
INSERT INTO job_request ("job", "loc", "date", "time", "desc") 
VALUES ('Delivery', 'KR', '2019-12-01', '12:30', 'Deliver parcel from Changi to Kent Ridge');
INSERT INTO job_request ("job", "loc", "date", "time", "desc") 
VALUES ('Food Delivery', 'KR', '2019-12-01', '18:30', 'Deliver food from Atlas Cafe to NUS');

INSERT INTO job_offer ("job", "loc", "date", "time", "desc") 
VALUES ('Assemble Furniture', 'AMK', '2019-08-05', '16:30', 'Help to assemble IKEA book shelf');
INSERT INTO job_offer ("job", "loc", "date", "time", "desc") 
VALUES ('Drive', 'CMW', '2019-08-19', '08:30', 'Drive me to Changi Airport');
INSERT INTO job_offer ("job", "loc", "date", "time", "desc") 
VALUES ('Babysitting', 'BG', '2019-08-25', '19:00', 'Look after my 3yo');
INSERT INTO job_offer ("job", "loc", "date", "time", "desc") 
VALUES ('Delivery', 'KR', '2019-12-01', '12:30', 'Deliver parcel from Jurong East to Kent Ridge');
