const sql = {}

sql.query = {
	// Login
	userpass: 'SELECT * FROM users WHERE username=$1',
	
	// Update
	update_info: 'UPDATE username_password SET first_name=$2, last_name=$3 WHERE username=$1',
	update_pass: 'UPDATE username_password SET password=$2 WHERE username=$1',
	
	// Query all tasks
	query_request: 'SELECT * FROM job_request',
	query_offer: 'SELECT * FROM job_offer',

	// Query tasks on user id
	query_request_user: 'SELECT * FROM job_request WHERE job_request.user=$1',
	query_offer_user: 'SELECT * FROM job_offer WHERE job_offer.user=$1',

	// Query tasks on job id
	query_request_job: 'SELECT * FROM job_request WHERE job_request.job_id=$1 AND $1 NOT IN (SELECT job_id FROM request_in_progress)',
	query_offer_job: 'SELECT * FROM job_offer WHERE job_offer.job_id=$1 AND $1 NOT IN (SELECT job_id FROM offer_in_progress)',
	query_bids_request: 'SELECT * from request_bids WHERE job_id=$1',
	query_bids_offer: 'SELECT * from offer_bids WHERE job_id=$1',

	// Query tasks on task name
	query_request_search: 'SELECT * FROM job_request WHERE LOWER(job_request.job) LIKE LOWER($1) and job_request.user=$2',
	query_offer_search: 'SELECT * FROM job_offer WHERE LOWER(job_offer.job) LIKE LOWER($1) and job_offer.user=$2',

	// Insert bids
	insert_request_bids: 'INSERT INTO request_bids VALUES($1, $2, $3, $4)',
	insert_offer_bids: 'INSERT INTO offer_bids VALUES($1, $2, $3, $4)',

	// Accept bid -> Add to in-progress table
	update_request_bids: 'INSERT INTO request_in_progress VALUES($1, $2)',
	update_offer_bids: 'INSERT INTO offer_in_progress VALUES($1, $2)'

}

module.exports = sql