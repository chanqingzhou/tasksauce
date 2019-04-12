# TaskSauce

TaskSauce is a task matching application whereby users can hire temporary help to complete certain tasks or offer their
services to those who are willing to pay for it. They can create new tasks requesting or offering for certain services, and
those willing to do it/pay them to do it can then bid for the tasks. The successful bidder will be chosen by the creator of
the task. Simply create an account now to get started!

This is a web application project created as a part of CS2102: Database Systems in the National University of Singapore.
It utilizes the following Software Tools/Frameworks:
- Web Server/Runtime Environment: NodeJS
- Web Application Framework: ExpressJS
- Front-end Styling Framework: Bootstrap
- Back-end Database Storage: PostgreSQL

Note to professor/grader: the password for every account in our database is the same as the username. The username and password for the admin account are both 'admin1'.

Set-up Guide
-------------

**Prerequisites**
- PostgreSQL should have been installed on your device
- NodeJS should have been installed on your device

1. Download the entire folder from the github repository https://github.com/chanqingzhou/tasksauce.
2. Run `npm install` on your Terminal to install all the required NodeJS packages.
3. Initialise your database on PostgreSQL by running the command `\i tasksauce.sql` in PostgreSQL.
  1. Do ensure that you are in the right directory containing the file `tasksauce.sql` before running it.
4. Add a `.dotenv` file containing your connection string in the following format: <br>
`DATABASE URL=postgres://username:password@host address:port/database name`.<br>
Modify the values as necessary according to your PostgreSQL configuration.
5. Run `node bin\www` on your Terminal to start the NodeJS server.
6. Go to `localhost:3000` on your preferred web browser and start using TaskSauce!

Credits
-------
- Created By: **[CS2102 AY18/19 Semester 2 Team 46]** Chan Qing Zhou, Lee Wei Kang, Koh Wei Xin, Pai Si Kai
- Styling Templates:
  - **Homepage**: https://startbootstrap.com/themes/landing-page/
  - **Sign-up & Login Page**: Colorlib Reg Form v34 https://colorlib.com/wp/free-bootstrap-registration-forms/
  - **New Request, New Offer, Edit Request & Edit Offer Pages**: Contact Form 15 by Colorlib https://colorlib.com/wp/free-html5-contact-form-templates/
