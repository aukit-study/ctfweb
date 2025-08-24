from flask import Flask, render_template, request, redirect, session
from flask_mysqldb import MySQL
import MySQLdb.cursors
from flask import render_template


app = Flask(__name__)
app.secret_key = 'your_secret_key'

# MySQL configuration
app.config['MYSQL_HOST'] = 'localhost'
app.config['MYSQL_USER'] = 'root'
app.config['MYSQL_PASSWORD'] = '4545650zx123'
app.config['MYSQL_DB'] = 'ctf_web'


mysql = MySQL(app)

# Home Page
@app.route('/')
def index():
    return render_template('index.html')

#404page
@app.errorhandler(404)
def page_not_found(e):
    return render_template('404.html'), 404

# Register Page
@app.route('/register', methods=['GET', 'POST'])
def register():
    if request.method == 'POST':
        name = request.form['name']
        username = request.form['username']
        password = request.form['password']

        cur = mysql.connection.cursor()
        try:
            cur.execute('INSERT INTO users (name,username, password, score) VALUES (%s,%s, %s, 0)', (name,username, password))
            mysql.connection.commit()
            return redirect('/login')
        except MySQLdb.IntegrityError:
            return "Username already exists."
        finally:
            cur.close()
    return render_template('register.html')

# Login Page
@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']

        cur = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cur.execute('SELECT * FROM users WHERE username = %s AND password = %s', (username, password))
        user = cur.fetchone()
        cur.close()

        if user:
            session['loggedin'] = True
            session['id'] = user['id']
            session['username'] = user['username']
            session['points'] = user['score']
            return redirect('/challenges')
        else:
            return "Invalid credentials. Try again."

    return render_template('login.html')

# Challenges Page
@app.route('/challenges', methods=['GET', 'POST'])
def challenges():
    if 'loggedin' not in session:
        return redirect('/login')

    cur = mysql.connection.cursor()
    message = None  # Initialize message as None to avoid NoneType issues

    if request.method == 'POST':
        flag = request.form['flag']
        challenge_id = request.form['challenge_id']

        # Check if the user already solved the challenge
        cur.execute('SELECT * FROM user_solved WHERE user_id = %s AND challenge_id = %s', (session['id'], challenge_id))
        already_solved = cur.fetchone()

        if already_solved:
            message = "You have already solved this challenge."
        else:
            # Validate the flag
            cur.execute('SELECT * FROM challenges WHERE id = %s AND flag = %s', (challenge_id, flag))
            challenge = cur.fetchone()

            if challenge:
                points = int(challenge[5])  # Assuming points is the 6th column
                cur.execute('UPDATE users SET score = score + %s WHERE id = %s', (points, session['id']))
                mysql.connection.commit()
                session['points'] += points  # Update session points

                cur.execute('INSERT INTO user_solved (user_id, challenge_id) VALUES (%s, %s)', (session['id'], challenge_id))
                mysql.connection.commit()
                message = f"Correct! +{points} points."
            else:
                message = "Incorrect flag. Try again."

        cur.close()
        return redirect(f'/challenges?message={message}&challenge_id={challenge_id}')

    # Fetch challenges data
    cur.execute('SELECT id, group_name, challenge_name, solve, points FROM challenges ORDER BY group_name, id')
    challenges_data = cur.fetchall()

    grouped_challenges = {}
    for challenge_id, group_name, challenge_name, solve, points in challenges_data:
        if group_name not in grouped_challenges:
            grouped_challenges[group_name] = []
        grouped_challenges[group_name].append({
            'id': challenge_id,
            'challenge_name': challenge_name,
            'solve': solve,
            'points': points
        })

    challenge_id = request.args.get('challenge_id')
    current_challenge = None
    if challenge_id:
        cur.execute('SELECT * FROM challenges WHERE id = %s', (challenge_id,))
        current_challenge = cur.fetchone()

    cur.close()

    return render_template(
        'challenges.html',
        grouped_challenges=grouped_challenges,
        current_challenge=current_challenge,
        message=request.args.get('message', ''),
        username=session.get('username'),
        points=session.get('points', 0)
    )
 
 
# 404 Page   
@app.route('/404')
def tournament():
    return render_template('page404.html')

# Scoreboard Page
@app.route('/scoreboard')
def scoreboard():
    cur = mysql.connection.cursor()
    cur.execute("SELECT username, score FROM users ORDER BY score DESC")  # Fetch users sorted by score
    users = [{'username': row[0], 'score': row[1]} for row in cur.fetchall()]
    cur.close()
    return render_template('scoreboard.html', users=users, enumerate=enumerate)

# Logout
@app.route('/logout')
def logout():
    session.clear()
    return redirect('/')

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5000, debug=True)

