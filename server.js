const express = require('express');
const app = express();
app.use(express.json());

const sessions = {};

setInterval(() => {
    const now = Math.floor(Date.now() / 1000);
    const MAX_INACTIVITY_SECONDS = 1800;

    for (const id in sessions) {
        const timeSinceLastAccess = now - sessions[id].lastAccessed;
        if (timeSinceLastAccess > MAX_INACTIVITY_SECONDS) {
            console.log(`Room ${id} deleted due to inactivity.`);
            delete sessions[id];
        }
    }
}, 30000);

app.get('/', (req, res) => {
    res.send('Online, yayyy');
});


app.post('/update', (req, res) => {
    const sessionId = req.headers['x-session-id'];
    if (!sessionId) return res.status(400).json({ error: "Missing ID" });

    
    const sessionExists = sessions[sessionId] !== undefined;

    sessions[sessionId] = {
        data: req.body,
        lastAccessed: Math.floor(Date.now() / 1000)
    };
    
    if (!sessionExists) {
        
        res.status(200).json({ success: true, message: "New Room Created!" });
    } else {
        
        res.status(200).json({ success: true, message: "Room Joined!" });
    }
});


app.get('/get-sync', (req, res) => {
    const sessionId = req.headers['x-session-id'];
    if (!sessionId) return res.status(400).json({ error: "Missing ID" });

    const session = sessions[sessionId];
    if (!session) {
        
        return res.status(200).json({ status: "Waiting for host to create room..." });
    }

    session.lastAccessed = Math.floor(Date.now() / 1000);
    res.status(200).json(session.data);
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));


app.get('/get-sync', (req, res) => {
    const sessionId = req.headers['x-session-id'];
    if (!sessionId) return res.status(400).json({ error: "Missing ID" });

    const session = sessions[sessionId];
    if (!session) {
        return res.status(200).json({}); 
    }

    session.lastAccessed = Math.floor(Date.now() / 1000);
    
    
    res.status(200).json(session.data || {}); 
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));
