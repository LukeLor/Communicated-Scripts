const express = require('express');
const app = express();
app.use(express.json());

let sharedData = {};

app.post('/update', (req, res) => {
    sharedData = req.body;
    res.status(200).json({ success: true });
});

app.get('/get-sync', (req, res) => {
    res.status(200).json(sharedData);
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));

app.get('/', (req, res) => {
    res.send('Sync server is online and running successfully!');
});
