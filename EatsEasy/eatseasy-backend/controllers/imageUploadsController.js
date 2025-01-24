const multer = require('multer'); // You'll need multer to handle form-data 


  
module.exports = {
    uploadImage: async (req, res) => {
        if (!req.file) {
          return res.status(400).send('No file uploaded.');
        }
      
        const blob = bucket.file(req.file.originalname);
      
        const blobWriter = blob.createWriteStream({
          metadata: {
            contentType: req.file.mimetype,
          },
        });
      
        blobWriter.on('error', (err) => {
          console.log(err);
          return res.status(500).send('Internal Server Error');
        });
      
        blobWriter.on('finish', () => {
          res.status(200).send('File uploaded.');
        });
      
        blobWriter.end(req.file.buffer);
      }
}