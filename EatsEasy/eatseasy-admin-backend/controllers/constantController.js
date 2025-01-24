const Constant = require("../models/Constant");
const Restaurant = require("../models/Restaurant");
const User = require("../models/User");
module.exports = {

    updateConstants : async (req, res) => {
            const { commissionRate, driverBaseRate } = req.body;

              // Validate the input
              if (commissionRate !== undefined && typeof commissionRate !== 'number') {
                return res.status(400).json({ message: 'commissionRate must be a number' });
              }
              if (driverBaseRate !== undefined && typeof driverBaseRate !== 'number') {
                return res.status(400).json({ message: 'driverBaseRate must be a number' });
              }

              try {
                const constants = await Constant.findOne();

                if (!constants) {
                  // If no constants document exists, create one
                  const newConstants = new Constant({
                    commissionRate: commissionRate || 10,  // Default to 10 if not provided
                    driverBaseRate: driverBaseRate || 20,  // Default to 20 if not provided
                  });
                  await newConstants.save();
                  return res.status(201).json(newConstants);
                }

                // Update the fields if provided
                if (commissionRate !== undefined) constants.commissionRate = commissionRate;
                if (driverBaseRate !== undefined) constants.driverBaseRate = driverBaseRate;

                await constants.save();
                return res.status(200).json(constants);
              } catch (error) {
                console.error(error);
                return res.status(500).json({ message: 'Server error' });
              }
        },

        getConstants : async (req, res) => {
                try {
                    const constants = await Constant.findOne();  // Assuming only one document in this collection
                    if (!constants) {
                      return res.status(404).json({ message: 'Constants not found' });
                    }
                    return res.status(200).json(constants);
                  } catch (error) {
                    console.error(error);
                    return res.status(500).json({ message: 'Server error' });
                  }
            },
}
