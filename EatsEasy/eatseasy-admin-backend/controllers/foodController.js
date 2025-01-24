const Food = require('../models/Food');

module.exports = {


    getFoods: async (req, res) => {
        const page   = req.query.page || 1;
        const ITEMS_PER_PAGE = req.query.limit || 1000;
        try {
            const foods = await Food.find({ isAvailable: req.query.status }, { __v: 0, createdAt: 0, updatedAt: 0})
                .sort({ createdAt: -1 })
                .skip((page - 1) * ITEMS_PER_PAGE)
                .limit(ITEMS_PER_PAGE);
            const totalItems = await Food.countDocuments({isAvailable: req.query.status  });
            
            res.status(200).json({
                foods,
                currentPage: +page,
                totalPages: Math.ceil(totalItems / ITEMS_PER_PAGE),
            });
        } catch (error) {
            res.status(500).json({ status: false, message: error.message });
        }
    },


    getFoodById: async (req, res) => {
        const id = req.params.id;
        try {
            const food = await Food.findById(id);

            res.status(200).json(food);
        } catch (error) {
            res.status(500).json({ status: false, message: error.message });
        }
    },




    //Restaurant Menu
    getFoodsByRestaurant: async (req, res) => {
        const id = req.params.id;

        try {
            const foods = await Food.find({ restaurant: id });

            res.status(200).json(foods);
        } catch (error) {
            res.status(500).json({ status: false, message: error.message });
        }
    },

    getFoodsByCategory: async (req, res) => {
        const { category } = req.params;
        try {
            const foods = await Food.find({category: category})

            res.status(200).json(foods);
        } catch (error) {
            res.status(500).json({ status: false, message: error.message });
        }
    },




};