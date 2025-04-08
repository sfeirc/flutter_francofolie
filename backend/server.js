const express = require('express');
const mysql = require('mysql2');
const cors = require('cors');
const app = express();
const port = 3000;

// Middleware
app.use(cors());
app.use(express.json());

// Credential
const db = mysql.createConnection({
    host: 'localhost',
    user: 'clovis',
    password: 'clovis',
    database: 'francofolies'
});

// Connexion bdd
db.connect((err) => {
    if (err) throw err;
    console.log('Connected to MySQL database');
});

// Routes
// Get tout les concerts
app.get('/api/concerts', (req, res) => {
    const query = `
        SELECT 
            c.*,
            s.nom_scene,
            s.lieu,
            s.capacité,
            GROUP_CONCAT(a.nom_artistes) as artistes,
            GROUP_CONCAT(t.type_tarif, ':', t.prix) as tarifs
        FROM CONCERTS c
        LEFT JOIN SCENES s ON c.id_scenes = s.id_scenes
        LEFT JOIN CONCERT_ARTISTE ca ON c.id_concert = ca.id_concert
        LEFT JOIN ARTISTES a ON ca.id_artistes = a.id_artistes
        LEFT JOIN TARIF t ON c.id_concert = t.id_concert
        GROUP BY c.id_concert
    `;
    
    db.query(query, (err, results) => {
        if (err) throw err;
        res.json(results);
    });
});

// Get concerts par scene
app.get('/api/concerts/scene/:sceneId', (req, res) => {
    const query = `
        SELECT 
            c.*,
            s.nom_scene,
            s.lieu,
            s.capacité,
            GROUP_CONCAT(a.nom_artistes) as artistes,
            GROUP_CONCAT(t.type_tarif, ':', t.prix) as tarifs
        FROM CONCERTS c
        LEFT JOIN SCENES s ON c.id_scenes = s.id_scenes
        LEFT JOIN CONCERT_ARTISTE ca ON c.id_concert = ca.id_concert
        LEFT JOIN ARTISTES a ON ca.id_artistes = a.id_artistes
        LEFT JOIN TARIF t ON c.id_concert = t.id_concert
        WHERE c.id_scenes = ?
        GROUP BY c.id_concert
    `;
    
    db.query(query, [req.params.sceneId], (err, results) => {
        if (err) throw err;
        res.json(results);
    });
});

// Get concerts par date
app.get('/api/concerts/date/:date', (req, res) => {
    const query = `
        SELECT 
            c.*,
            s.nom_scene,
            s.lieu,
            s.capacité,
            GROUP_CONCAT(a.nom_artistes) as artistes,
            GROUP_CONCAT(t.type_tarif, ':', t.prix) as tarifs
        FROM CONCERTS c
        LEFT JOIN SCENES s ON c.id_scenes = s.id_scenes
        LEFT JOIN CONCERT_ARTISTE ca ON c.id_concert = ca.id_concert
        LEFT JOIN ARTISTES a ON ca.id_artistes = a.id_artistes
        LEFT JOIN TARIF t ON c.id_concert = t.id_concert
        WHERE DATE(c.date_concert) = ?
        GROUP BY c.id_concert
    `;
    
    db.query(query, [req.params.date], (err, results) => {
        if (err) throw err;
        res.json(results);
    });
});

// Get concert par artistes
app.get('/api/concerts/artist/:artistId', (req, res) => {
    const query = `
        SELECT 
            c.*,
            s.nom_scene,
            s.lieu,
            s.capacité,
            GROUP_CONCAT(a.nom_artistes) as artistes,
            GROUP_CONCAT(t.type_tarif, ':', t.prix) as tarifs
        FROM CONCERTS c
        LEFT JOIN SCENES s ON c.id_scenes = s.id_scenes
        LEFT JOIN CONCERT_ARTISTE ca ON c.id_concert = ca.id_concert
        LEFT JOIN ARTISTES a ON ca.id_artistes = a.id_artistes
        LEFT JOIN TARIF t ON c.id_concert = t.id_concert
        WHERE ca.id_artistes = ?
        GROUP BY c.id_concert
    `;
    
    db.query(query, [req.params.artistId], (err, results) => {
        if (err) throw err;
        res.json(results);
    });
});

// Get tout les concerts
app.get('/api/scenes', (req, res) => {
    const query = 'SELECT * FROM SCENES';
    db.query(query, (err, results) => {
        if (err) throw err;
        res.json(results);
    });
});

// Get tout les artiste
app.get('/api/artists', (req, res) => {
    const query = 'SELECT * FROM ARTISTES';
    db.query(query, (err, results) => {
        if (err) throw err;
        res.json(results);
    });
});

app.listen(port, '172.26.240.243', () => {
    console.log(`Server running at http://172.26.240.243:${port}`);
}); 