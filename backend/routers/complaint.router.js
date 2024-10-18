const router = require('express').Router();

const ComplaintController = require("../controller/complaint.controller");

router.post('/complaintDetails', ComplaintController.raiseComplaint);

router.post('/getComplaintDetails', ComplaintController.getComplaintDetails);

router.post('/deleteComplaint', ComplaintController.deleteComplaint);

router.post('/updateStatus', ComplaintController.updateComplaintDetails);

router.post('/bulk', ComplaintController.searchDetails);

router.post('/uploadPhoto', ComplaintController.uploadPhoto);

module.exports = router;