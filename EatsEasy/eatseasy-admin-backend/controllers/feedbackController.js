const  Feedback = require('../models/FeedBack');

module.exports = {
    getFeedback: async (req, res) => {
        const page = 1, status  = req.query;
        const ITEMS_PER_PAGE = req.query.limit || 1000;
        try {
            let query = {};
            if (status) {
                query = { status: req.query.status };
            }

            const totalItems = await Feedback.countDocuments(query);

            const feedbackx = await Feedback.find(query, { updatedAt: 0, __v: 0})
                .populate(
                    'userId',
                    'profile username'
                )
                .sort({ createdAt: -1 })
                .skip((page - 1) * ITEMS_PER_PAGE)
                .limit(ITEMS_PER_PAGE);

            res.status(200).json({
                feedbackx,
                currentPage: +page,
                totalPages: Math.ceil(totalItems / ITEMS_PER_PAGE),
            });
        } catch (error) {
            res.status(500).json({ status: false, message: error.message });
        }
    },
}