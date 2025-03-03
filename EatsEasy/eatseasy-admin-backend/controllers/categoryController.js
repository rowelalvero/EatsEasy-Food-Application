const Category = require('../models/Category');

module.exports = {

    createCategory: async (req, res) => {
        const newCategory = new Category(req.body);
        try {
            await newCategory.save();
            res.status(201).json({ status: true, message: "Category created successfully" });
        } catch (error) {
            res.status(500).json({ status: false, message: error.message });
        }
    },

    getAllCategories: async (req, res) => {
        console.log(req.query);
        const page   = req.query.page || 1;
        const ITEMS_PER_PAGE = req.query.limit || 1000;
        try {
            const categories = await Category.find({ title: { $ne: "More" } }, { __v: 0, createdAt: 0, updatedAt: 0})
                .sort({ createdAt: -1 })
                .skip((page - 1) * ITEMS_PER_PAGE)
                .limit(ITEMS_PER_PAGE);
            const totalItems = await Category.countDocuments({ title: { $ne: "More" } });
            
            res.status(200).json({
                categories,
                currentPage: +page,
                totalPages: Math.ceil(totalItems / ITEMS_PER_PAGE),
            });
        } catch (error) {
            res.status(500).json({ status: false, message: error.message });
        }
    },

    updateCategory:  async (req, res) => {
            const id = req.params.id;
            const {title,value, imageUrl } = req.body;



            try {

                const updatedCategory = await Category.findByIdAndUpdate(id, {
                    title: title,
                    value: value,
                    imageUrl: imageUrl
                }, { new: true });  // This option ensures the updated document is returned

                if (!updatedCategory) {
                    return res.status(404).json({ status: false, message: 'Category not found.' });
                }

                res.status(200).json({ status: true, message: 'Category successfully updated'});
            } catch (error) {
                console.error("Error updating category:", error);
                res.status(500).json({ status: false, message: 'An error occurred while updating the category.' });
            }
        },

    deleteCategory: async (req, res) => {
            const { id } = req.params;

            if (!id) {
                return res.status(400).json({ status: false, message: 'Category ID is required for deletion.' });
            }

            try {
                await Category.findByIdAndRemove(id);

                res.status(200).json({ status: true, message: 'Category successfully deleted' });
            } catch (error) {
                console.error("Error deleting category:", error);
                res.status(500).json({ status: false, message: 'An error occurred while deleting the category.' });
            }
        },

    patchCategoryImage: async (req, res) => {
                const id  = req.params;
                const imageUrl  = req.body;

                try {
                    const existingCategory = await Category.findById({_id: id} );  // This option ensures the updated document is returned

                    const updatedCategory = new Category({
                        title: existingCategory.title,
                        value: existingCategory.value,
                        imageUrl: imageUrl
                    })

                    await updatedCategory.save();

                    res.status(200).json({ status: true, message: 'Category image successfully patched', data: updatedCategory });
                } catch (error) {
                    console.error("Error patching category image:", error);
                    res.status(500).json({ status: false, message: 'An error occurred while patching the category image.' });
                }
            },

    getRandomCategories: async (req, res) => {
                try {
                    let categories = await Category.aggregate([
                        { $match: { value: { $ne: "more" } } },  // Exclude the "more" category from random selection
                        { $sample: { size: 4 } }  // Get 7 random categories
                    ]);

                    // Find the "More" category in the database
                    const moreCategory = await Category.findOne({ value: "more" });

                    if (moreCategory) {
                        categories.push(moreCategory);
                    }

                    res.status(200).json(categories);
                } catch (error) {
                    console.error("Error fetching limited categories:", error);
                    res.status(500).json({ status: false, message: 'An error occurred while fetching the categories.' });
                }
            }
};