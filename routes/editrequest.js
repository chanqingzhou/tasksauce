const sql_query = require('../sql');
var express = require('express');
var router = express.Router();

const { Pool } = require('pg')
const pool = new Pool({
	connectionString: process.env.DATABASE_URL
});

/* SQL Query */
var sql_query_is_admin = sql_query.query.is_admin;
var sql_query_request = sql_query.query.query_request_job;
var sql_query_edit = sql_query.query.edit_request;

// GET
router.get('/:jobId', function(req, res, next) {
	pool.query(sql_query_is_admin, [req.user.username], (err, isAdmin) => {
		pool.query(sql_query_request, [req.params.jobId], (err1, request) => {
			if (!err && !err1) {
				if (req.isAuthenticated && (isAdmin.rows[0].is_admin || request.rows[0].username === req.user.username)) {
					console.log("User [" + req.user.username + "] is going to edit request");
					res.render('editrequest', { title: 'Edit Request', request: request.rows });
				} else if (req.isAuthenticated && !(isAdmin.rows[0].is_admin || request.rows[0].username === req.user.username)) {
					// TODO: Handle non-admin attempt to access
					res.redirect('../');
				} else {
					res.redirect('../signuplogin');
				}
			} else {
				console.log("Admin and/or auth check failed");
			}
		})
	})
});

// POST
router.post('/:jobId', function(req, res, next) {
	// Retrieve Information from Form
	var job = req.body.job;
	var loc = req.body.loc;
	var date= req.body.date;
	var time = req.body.time;
	var details = req.body.details;

	pool.query(sql_query_edit, [req.params.jobId, job, loc, date, time, details], (err) => {
		if (err) { 
			throw err;
		} else {
			console.log("Successfully edited Request [jobId: " + req.params.jobId + "]");
			res.redirect('/requests');
		}
	})
});

module.exports = router;
