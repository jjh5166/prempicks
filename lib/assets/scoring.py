import http.client, sys, os, json, boto3
from os.path import join, dirname
from dotenv import load_dotenv

dotenv_path = join(dirname(__name__), '.env')
load_dotenv(dotenv_path)
APIkey = str(os.getenv('FOOTBALL_API_KEY'))
AwsAccessKeyID = str(os.getenv('AWS_ACCESS_KEY_ID'))
AwsSecretAccessKey = str(os.getenv('AWS_SECRET_ACCESS_KEY'))
AwsRegion = str(os.getenv('AWS_REGION'))
AwsBucket = str(os.getenv('S3_BUCKET'))

matchday = str(sys.argv[1])
request_string = f'/v2/competitions/PL/matches/?matchday={matchday}'


connection = http.client.HTTPConnection('api.football-data.org')
headers = {'X-Auth-Token': APIkey}
connection.request('GET', request_string, None, headers)
response = json.loads(connection.getresponse().read().decode())

s3 = boto3.resource(
    's3',
    region_name=AwsRegion,
    aws_access_key_id=AwsAccessKeyID,
    aws_secret_access_key=AwsSecretAccessKey
)

with open('app/assets/data/code_to.json') as jfile:
    teamcodes = json.load(jfile)

content = s3.Object(AwsBucket, 'lastyr.json')
file_content = content.get()['Body'].read().decode('utf-8')
lastszn = json.loads(file_content)['standings']

topSix = lastszn[:6]
newThree = lastszn[17:]


class ScoreMatch:
    def __init__(self, data):
        self.hGoals = data['score']['fullTime']['homeTeam']
        self.aGoals = data['score']['fullTime']['awayTeam']
        self.hTeam = teamcodes[str(data['homeTeam']['id'])]['abv']
        self.aTeam = teamcodes[str(data['awayTeam']['id'])]['abv']

        if self.hGoals == self.aGoals:
            self.draw(data)
        else:
            self.tally(self.hGoals, self.aGoals)
            self.assignTeams(data, self.diff)
            self.topSixOrNew(self.wTeam, self.lTeam)

    def draw(self, data):
        self.wTeam = teamcodes[str(data['homeTeam']['id'])]['abv']
        self.lTeam = teamcodes[str(data['awayTeam']['id'])]['abv']
        self.wScore = self.lScore = 1

    def tally(self, goals1, goals2):
        self.diff = goals1-goals2
        cs = True if goals1*goals2 == 0 else False
        self.wScore = 3 if abs(self.diff) >= 3 else 2
        if cs:
            self.wScore += 1
        self.lScore = -4 if abs(self.diff) >= 3 else -3

    def topSixOrNew(self, winner, loser):
        if loser in topSix:
            self.lScore -= 1
            self.wScore += 1
        if winner in newThree:
            self.wScore += 1

    def assignTeams(self, data, diff):
        if diff > 0:
            self.wTeam = teamcodes[str(data['homeTeam']['id'])]['abv']
            self.lTeam = teamcodes[str(data['awayTeam']['id'])]['abv']
        else:
            self.wTeam = teamcodes[str(data['awayTeam']['id'])]['abv']
            self.lTeam = teamcodes[str(data['homeTeam']['id'])]['abv']


scores = {}
for m in response['matches']:
    if m['status'] == "FINISHED":
        match = ScoreMatch(m)
        scores[match.wTeam] = match.wScore
        scores[match.lTeam] = match.lScore

scores_json = json.dumps(scores)

filename = 'scores/matchday' + matchday + '.json'

s3.Object(AwsBucket, filename).put(Body=scores_json)
