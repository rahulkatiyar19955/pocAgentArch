module.exports = function(app) {
    app.get('/some', (req, res) => {
        res.send('Hello World! some');
      })
}