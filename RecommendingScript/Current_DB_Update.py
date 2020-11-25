from bs4 import BeautifulSoup
from datetime import datetime, timedelta
from urllib.request import urlopen
import requests
import json
from google.cloud import storage
 
db = storage.Client()
 
 
 
def crawling_genre(link):
    
    page = urlopen("https://movie.naver.com" + link) 
    soup = BeautifulSoup(page, "html.parser")
    movie_genre = ""
    
    
    for n in soup.select_one('dl.info_spec > dd> p> span').select('a'):
        movie_genre += n.string+" "
 
    return movie_genre
    
 
def crawling_img(link):
    page = urlopen("https://movie.naver.com" + link) 
    soup = BeautifulSoup(page, "html.parser")
    movie_img = soup.find('div', 'mv_info_area').find('img').get('src')
 
    return movie_img
 
    
def crawling_gender(link):
    try:
        html = requests.get("https://movie.naver.com" + link).text
        matched = re.search(r'aActualGenderPointData = (.*?);', html, re.S)
        list = json.loads(matched.group(1))
        
        return str(list[0]['sPer']) +" "+str(list[1]['sPer'])
    
    except:
        return "50 50"
    
    
 
def crawling_age(link):
    
    try:
        page = urlopen("https://movie.naver.com" + link)
        soup = BeautifulSoup(page, "html.parser")
        age1 = soup.select_one("div.mv_info > div.viewing_graph > div.graph_wrap > div.bar_graph > div.graph_box:nth-child(1)> strong.graph_percent").getText().replace("%","")
        age2 = soup.select_one("div.mv_info > div.viewing_graph > div.graph_wrap > div.bar_graph > div.graph_box:nth-child(2)> strong.graph_percent").getText().replace("%","")
        age3 = soup.select_one("div.mv_info > div.viewing_graph > div.graph_wrap > div.bar_graph > div.graph_box:nth-child(3)> strong.graph_percent").getText().replace("%","")
        age4 = soup.select_one("div.mv_info > div.viewing_graph > div.graph_wrap > div.bar_graph > div.graph_box:nth-child(4)> strong.graph_percent").getText().replace("%","")
        age5 = soup.select_one("div.mv_info > div.viewing_graph > div.graph_wrap > div.bar_graph > div.graph_box:nth-child(5)> strong.graph_percent").getText().replace("%","")
 
        return age1 +" "+ age2 +" "+ age3 +" "+ age4 +" "+ age5
    
    except:
        return "25 25 25 25 25"
        
 
# def crawling_enjoy(link):
#     link = link.replace('basic', 'point')
#     page = urlopen("https://movie.naver.com" + link) 
#     soup = BeautifulSoup(page, "html.parser")
#     movie_enjoy = ""
 
#     try:
#         for n in soup.select('#netizen_point_graph > div > div.grp_sty4 > ul > li'):
#             movie_enjoy += n.select('span.grp_score')[0].string
 
#         return movie_enjoy
    
#     except:
#         return '25%25%25%25%25%'
 
# def crawling_score(link):
#     link = link.replace('basic', 'point')
#     page = urlopen('https://movie.naver.com' + link) 
#     soup = BeautifulSoup(page, "html.parser")
    
#     try:
#         score = soup.select_one('#netizen_point_graph > div > div.grp_wrap > div.grp_gender > div:nth-child(1) > div > strong.graph_point').text
#         score  += ' ' + soup.select_one('#netizen_point_graph > div > div.grp_wrap > div.grp_gender > div:nth-child(2) > div > strong.graph_point').text
#         score  += ' ' + soup.select_one('#netizen_point_graph > div > div.grp_wrap > div.grp_age > div.grp_box.high_percent > strong.graph_point').text
#         score += ' ' + soup.select_one('#netizen_point_graph > div > div.grp_wrap > div.grp_age > div:nth-child(2) > strong.graph_point').text
#         score += ' ' + soup.select_one('#netizen_point_graph > div > div.grp_wrap > div.grp_age > div:nth-child(3) > strong.graph_point').text
#         score += ' ' + soup.select_one('#netizen_point_graph > div > div.grp_wrap > div.grp_age > div:nth-child(4) > strong.graph_point').text
#         score += ' ' + soup.select_one('#netizen_point_graph > div > div.grp_wrap > div.grp_age > div:nth-child(5) > strong.graph_point').text
    
#         return score
    
#     except:
#         return '0.50 0.50 0.50 0.50 0.50 0.50 0.50'
 
 
 
def crawling_content(link):
    page = urlopen("https://movie.naver.com" + link) 
    soup = BeautifulSoup(page, "html.parser")
 
    try:
        movie_content= soup.find('p', 'con_tx').text
 
        return movie_content
    
    except:
        return ''
 
def crawling_nation(link):
    
    page = urlopen("https://movie.naver.com" + link) 
    soup = BeautifulSoup(page, "html.parser")
    movie_nation = ""
    
    for n in soup.select('dl.info_spec > dd > p > span')[1].select('a'):
        movie_nation += n.string+" "
 
    return movie_nation
 
 
def crawling_time(link):
    
    page = urlopen("https://movie.naver.com" + link) 
    soup = BeautifulSoup(page, "html.parser")
    movie_time = ""
    
    for n in soup.select('#content > div.article > div.mv_info_area > div.mv_info > dl > dd:nth-child(2) > p > span:nth-child(3)'):
        movie_time += n.string+" "
 
    return movie_time
 
 
def crawling_date(link):
    
    page = urlopen("https://movie.naver.com" + link) 
    soup = BeautifulSoup(page, "html.parser")
    movie_date = ""
    
    for n in soup.select('dl.info_spec > dd > p > span')[3].select('a'):
        movie_date += n.string+" "
 
    return movie_date
 
def crawling_enjoy(link):
    link = link.replace('basic', 'point')
    page = urlopen("https://movie.naver.com" + link) 
    soup = BeautifulSoup(page, "html.parser")
    movie_enjoy = ""
 
    try:
        for n in soup.select('#netizen_point_graph > div > div.grp_sty4 > ul > li'):
            movie_enjoy += n.select('span.grp_score')[0].string
 
        return movie_enjoy
    
    except:
        return '0%0%0%0%0%'
 
def crawling_score(link):
    link = link.replace('basic', 'point')
    page = urlopen('https://movie.naver.com' + link) 
    soup = BeautifulSoup(page, "html.parser")
    
    try:
        score = soup.select_one('#netizen_point_graph > div > div.grp_wrap > div.grp_gender > div:nth-child(1) > div > strong.graph_point').text
        score  += ' ' + soup.select_one('#netizen_point_graph > div > div.grp_wrap > div.grp_gender > div:nth-child(2) > div > strong.graph_point').text
        score  += ' ' + soup.select_one('#netizen_point_graph > div > div.grp_wrap > div.grp_age > div.grp_box.high_percent > strong.graph_point').text
        score += ' ' + soup.select_one('#netizen_point_graph > div > div.grp_wrap > div.grp_age > div:nth-child(2) > strong.graph_point').text
        score += ' ' + soup.select_one('#netizen_point_graph > div > div.grp_wrap > div.grp_age > div:nth-child(3) > strong.graph_point').text
        score += ' ' + soup.select_one('#netizen_point_graph > div > div.grp_wrap > div.grp_age > div:nth-child(4) > strong.graph_point').text
        score += ' ' + soup.select_one('#netizen_point_graph > div > div.grp_wrap > div.grp_age > div:nth-child(5) > strong.graph_point').text
    
        return score
    
    except:
        return '0.00 0.00 0.00 0.00 0.00 0.00 0.00'
 
def crawling_level(link):
    page = urlopen("https://movie.naver.com" + link) 
    soup = BeautifulSoup(page, "html.parser")
 
    try:
        movie_level= soup.find('dl', 'info_spec').find_all('dd')
 
        return movie_level[3].a.text
    
    except:
        return ''
 
 
def crawling_people(link):
    try:
        page = urlopen("https://movie.naver.com" + link) 
        soup = BeautifulSoup(page, "html.parser")
        people= {n.find('img').get('alt'):n.find('img').get('src') for n in soup.find_all('a', 'thumb_people')}
        return people
    except:
        return ''
    
    
    
def crawling_time_table(link):
    
    region = {
        '서울' : 1,
        '인천' : 2,
        '경기' : 3,
        '대전' : 4,
        '충청' : 4,
        '강원' : 6,
        '광주' : 7,
        '전라' : 8,
        '부산' : 9,
        '대구' : 10,
        '경상' : 11,
        '제주' : 12
        
    }
    
    
    
    current_day = datetime.today()
    current_day = current_day.strftime('%Y-%m-%d')
    
 
    url = link.replace('basic', 'running')
    
    
    region_page = urlopen('https://movie.naver.com' + url)
 
    region_soup = BeautifulSoup(region_page, 'html.parser')
 
    nums = [region[n.text] for n in region_soup.select('#rootDropBox > li> a')]
    
    
     
    
    result = {}
    
    for regionRootCode in nums:
        
        
        
        params = '&regionRootCode={}&regionSubCode=0&reserveDate={}&sort=0'.format(regionRootCode, current_day)
 
        temp_page = requests.post('https://movie.naver.com' + url, params=params)
 
        temp_soup = BeautifulSoup(temp_page.text, 'html.parser')
        
        count = 0
        
        result[str(regionRootCode)] = []
        
        for data in temp_soup.select('#paging > a'):
            
            if data.text.isdigit():
                count +=1
        
        temp = {}
        for page in range(count):
    
            params = '&regionRootCode={}&regionSubCode=0&reserveDate={}&sort=0&page={}'.format(regionRootCode, current_day, page+1)
 
            page = requests.post('https://movie.naver.com' + url, params=params)
 
            soup = BeautifulSoup(page.text, 'html.parser')
            
            for data in soup.select('div.rsv_area'):
                temp[data.select_one('p>strong>a').text] = [n.text for n in data.select('div.rsv_time')]
        
        
        result[str(regionRootCode)] += [temp]
        
    return result
        
 
 
 
def current_update_db(data, context):
    
    
    page = urlopen('https://movie.naver.com/movie/running/current.nhn') 
 
    soup = BeautifulSoup(page, 'html.parser')
    
    time = 'currentData'
    
    movie_name_kor = []
 
    movie_point = []
    
    movie_link = []
    
    movie_rate = []
    
    movie_genre = []
    
    
    
 
    for child in soup.select('#content > div.article > div:nth-child(1) > div.lst_wrap > ul > li'):
 
        try:
            rate = child.select('dl.lst_dsc > dd.star > dl.info_exp > dd > div > span.num')[0].text
            child.select('dl > dd:nth-child(2) > span.link_txt > a')[0].text
            temp = crawling_genre(child.select('dl.lst_dsc > dt.tit > a')[0]['href'])
            print(float(rate))
            
            if float(rate) > 0.01:
                movie_name_kor += [child.select('dl.lst_dsc > dt.tit > a')[0].text]
                movie_point += [child.select('dl.lst_dsc > dd.star > dl.info_star > dd > div.star_t1 > a > span.num')[0].text]
                movie_rate += [child.select('dl.lst_dsc > dd.star > dl.info_exp > dd > div > span.num')[0].text]
                movie_link += [child.select('dl.lst_dsc > dt.tit > a')[0]['href']]
                movie_genre += [temp]
            
            
        except:
            continue
    
    print(' movie_name_kor is success')
    print(' movie_point is success')
    print(' movie_link is success')
    print(' movie_reate is success')
    print(' movie_genre is success')
 
 
    movie_img = [crawling_img(n) for n in movie_link]
    print(' movie_img is success')
    movie_gender = [crawling_gender(n) for n in movie_link]
    print(' movie_gender is success')
    movie_content = [crawling_content(n) for n in movie_link]
    print(' movie_content is success')
    movie_age = [crawling_age(n) for n in movie_link]
    print(' movie_age is success')
    movie_nation = [crawling_nation(n) for n in movie_link]
    print(' movie_nation is success')
    movie_time = [crawling_time(n) for n in movie_link]
    print(' movie_time is success')
    movie_date = [crawling_date(n) for n in movie_link]
    print(' movie_date is success')
    movie_director = []
    movie_people = []
    
    for n in movie_link:
        temp1 = crawling_people(n)
        temp_index = list(temp1.keys())[0]
 
        movie_director += [{temp_index:temp1[temp_index]}]
        del temp1[temp_index]
        movie_people += [temp1]
        
    print(' movie_direcotr is success')
    print(' movie_people is success')
    movie_enjoy = [crawling_enjoy(n) for n in movie_link]
    print(' movie_enjoy is success')
    movie_score = [crawling_score(n) for n in movie_link]
    print(' movie_score is success')
    movie_level = [crawling_level(n) for n in movie_link]
    print(' movie_level is success')
    movie_timetable = [crawling_time_table(n) for n in movie_link]
    print(' movie_timetable is sucess')
    
    
    ref = db.collection("movieData").document(time)
    print(' dbloading is success')
    ref.set({
        'name': movie_name_kor,
        'point' : movie_point,
        'link' : movie_link,
        'genre' : movie_genre,
        'gender' : movie_gender,
        'age' : movie_age,
        'img' : movie_img,
        'nation' : movie_nation,
        'time' : movie_time,
        'date' : movie_date,
        'director' : movie_director,
        'people' : movie_people,
        'enjoy' : movie_enjoy,
        'score' : movie_score,
        'content' : movie_content,
        'level' : movie_level,
        'rate' : movie_rate,
        'timetable':movie_timetable
        
    })
    print(' dbsave is success')
