const mongoose = require('mongoose');

const ConstantSchema = new mongoose.Schema(
  {
    commissionRate: { type: Number, required: true, default: 10 },
    driverBaseRate: { type: Number, required: true, default: 20 },
  },
);

module.exports = mongoose.model('Constant', ConstantSchema);  // Model name 'Constant'
