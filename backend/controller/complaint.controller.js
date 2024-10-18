const ComplaintServices = require("../services/complaint.services");

exports.raiseComplaint = async (req, res, next) => {
    try {
        const { userId, email, image, location, category, description } = req.body;

        let complaint = await ComplaintServices.raiseComplaint(userId, email, image, location, category, description);

        res.json({ status: true, success: complaint });
    }
    catch (error) {
        next(error);
    }
}

exports.getComplaintDetails = async (req, res, next) => {
    try {
        const email = req.body.email;

        let complaint = await ComplaintServices.getComplaintdetails(email);

        let allcounts = await ComplaintServices.getComplaintCount(email);

        let count = await ComplaintServices.getAllComplaintCount();

        res.json({ status: true, count: allcounts, allCount: count, success: complaint });
    }
    catch (error) {
        next(error);
    }
}

exports.deleteComplaint = async (req, res, next) => {
    try {
        const { id } = req.body;

        let deleted = await ComplaintServices.deleteComplaint(id);

        res.json({ status: true, success: deleted });
    }
    catch (error) {
        next(error);
    }
}

exports.updateComplaintDetails = async (req, res, next) => {
    try {
        const { id, status } = req.body;

        let update = await ComplaintServices.updateComplaintDetails(id, status);

        res.json({ status: true, success: update });
    }
    catch (error) {
        next(error);
    }
}

exports.searchDetails = async (req, res, next) => {
    try {
        const filter = req.query.filter || "";

        const complaint = await ComplaintServices.searchDetails(filter);

        res.json({ status: true, success: complaint });
    }
    catch (error) {
        next(error);
    }
}

exports.uploadPhoto = async (req, res, next) => {
    try {
        const { email } = req.body;

        const { type } = req.body;

        let photoUpload = await ComplaintServices.uploadPhoto(email, type);

        res.json({ status: true, success: photoUpload });
    }
    catch (error) {
        next(error);
    }
}
