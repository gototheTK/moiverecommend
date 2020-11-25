#!/usr/bin/env python
# coding: utf-8
from google.cloud import firestore
import time
import numpy as np
 
db = firestore.Client()
current_ref = db.collection('movieData')
current = current_ref.document('currentData').get().to_dict()
 
# ### 필요한 수식들
def cos_similarity(v1, v2):
    np1 = np.array(v1)
    np2 = np.array(v2)
    dot_product = np.dot(np1,np2)
    l2_norm = (np.sqrt(sum(np.square(v1))))*np.sqrt(sum(np.square(v2)))
    similarity = dot_product / l2_norm
    
    return similarity
 
 
def distance(v1, v2):
    temp = np.array(v1) - np.array(v2)
    result = 0
    for n in temp:
        result = result + (n)**2
    return np.sqrt(result)
 
 
# #### 장르, 성별, 연령대의 각각 유사도를 구한다.
# 1. 장르 유사도를 구한다.
# 2. 성별 유사도를 구한다.
# 3. 연령대 유사도를 구한다.
 
# * 장르 코사인유사도를 구한다.
 
 
movie_genre = [ '드라마'
               , '판타지'
               , '서부'
               , '공포'
               , '멜로/로맨스'
               , '모험'
               , '스릴러'
               , '느와르'
               , '컬트'
               , '다큐멘터리'
               , '코미디'
               , '가족'
               , '미스터리'
               , '전쟁'
               , '애니메이션'
               , '범죄'
               , '뮤지컬'
               , 'SF'
               , '액션'
               , '무협'
               , '에로'
               , '서스펜스'
               , '서사'
               , '블랙코미디'
               , '실험'
               , '공연실황']
 
def make_basic_genre_vectors(movie_genre):
    result = {}
    for i in range(len(movie_genre)):
        temp = list(map(lambda x: 0, movie_genre))
        temp[i] = 1
        result[movie_genre[i]] = temp
    return result
 
basic_genre_vectors = make_basic_genre_vectors(movie_genre)
 
 
def make_movie_genre_vectors(names, genres):
    result = {}
    for i in range(len(names)):
        temp = list(map(lambda x: 0, movie_genre))
        for data in genres[i].split():
            temp = [(x+y) for x,y in zip(temp,basic_genre_vectors[data])]
        result[names[i]] = temp
    return result
 
 
 
def standard_genre_vecotor(genres, movie_genre_vectors):
    temp = []
    result = []
    for data1 in genres:
        for data2 in data1.split():
            temp.append(data2)
    
    for data3 in movie_genre_vectors:
        result.append(temp.count(data3))
        
    return result
 
 
def genre_similarity(names,standard, genres):
 
    temp = {}
    result = []
    user_vectors = make_movie_genre_vectors(names, genres)
    
    tempVector = list(map(lambda x: 1 if x==0 else x, standard))
    for key in user_vectors.keys():
        temp2 = [(x*y) for x,y in zip(tempVector,user_vectors[key])]
        temp[key] = cos_similarity(standard, temp2)
    
    for index in range(len(names)):
        result.append(temp[names[index]])
        
    return result
 
 
 
# * 취향 코사인유사도를 구한다.
# 
# gender = [남,여]
# 
# age = [10대, 20대, 30대, 40대, 50대]
# 
# score = [남자, 여자, 10대, 20대, 30대, 40대, 50대]
 
 
movie_prefer = ['10대 남자', '20대 남자', '30대 남자', '40대 남자', '50대 남자'
               ,'10대 여자', '20대 여자', '30대 여자', '40대 여자', '50대 여자']
 
 
def standard_prefer_vector(genders, ages, scores):
    result = list(map(lambda x: float(0.0), range(10)))
    
    for gender, age, score in zip(genders, ages, scores):
        temp1 = gender.split() + age.split()
        temp2 = score.split()
        for i in range(len(result)):
            if i < 5:
                result[i] += (float(temp1[0])*float(temp2[0])*float(temp2[i+2])*float(temp1[i+2]))/10000
            else:
                result[i] += (float(temp1[1])*float(temp2[1])*float(temp2[i-3])*float(temp1[i-3]))/10000
        
    return [x for x in result]
 
 
 
def prefer_similrality(standard, genders, ages, scores):
    result = []
    temp = list(map(lambda x: float(0.0), range(10)))
    
    for gender, age, score in zip(genders, ages, scores):
        temp1 = gender.split() + age.split()
        temp2 = score.split()
        for i in range(len(temp)):
            if i < 5:
                temp[i] += float(temp1[0])*float(temp2[0])*float(temp2[i+2])/10000
            else:
                temp[i] += float(temp1[1])*float(temp2[1])*float(temp2[i-3])/10000
        result.append(cos_similarity(standard, temp))
        temp = list(map(lambda x: float(0.0), range(10)))
        
                      
    return result
 
 
 
# * 감상포인트 코사인유사도를 구한다.
# 
# 연출/연기/스토리/영상미/OST
 
 
movie_enjoy = ['연출', '연기', '스토리', '영상미', 'OST']
 
 
 
def standard_enjoy_vector(enjoys):
    result = [0.0, 0.0, 0.0, 0.0, 0.0]
    
    for enjoy in enjoys:
        temp = enjoy.replace("%", " ").split()
        result[0] += float(temp[0])
        result[1] += float(temp[1])
        result[2] += float(temp[2])
        result[3] += float(temp[3])
        result[4] += float(temp[4])
        
    for i in range(len(result)):
        result[i] = result[i]
        
    return result
 
 
 
def enjoy_similrality(standard, enjoys):
    result = []
    for enjoy in enjoys:
        temp = list(map(lambda x: float(x), enjoy.replace("%"," ").split()))
        result.append(cos_similarity(standard, temp))
        
    return result
 
 
 
 
 
def movie_vectors(names, genres, prefers, enjoys, point):
    result = {}
    
    for i in range(len(names)):
        result[names[i]] = [genres[i], prefers[i], enjoys[i], float(point[i])*0.1]
        
    return result
 
 
 
# #### 추천알고리즘
# * 1,1,1와의 거리를 구해 정렬한다.
 
 
def distance_array(movies):
    
    result1 = []
    result2 = []
    for movie in movies.keys():
        result1.append(distance(movies[movie], [1.0, 1.0, 1.0, 1.0]))
        result2.append(movie)
    
    return (result1, result2)
 
def min_array(names, values):
    
    result1 = []
    result2 = []
    result3 = []
    for temp in np.argsort(values):
        result1.append(names[temp])
        result2.append(temp)
        result3.append(values[temp])
    
    return (result1, result2, result3)
 
 
 
 
def result_update(User, rocommended_moveis, result_distances):
    doc_write = db.collection(User)
        
    for value, rank in zip(rocommended_moveis,range(len(rocommended_moveis))):
                           
        index = current['name'].index(value)
                                             
        recommend_score=round(((2-result_distances[index])/2)*100, 2)
        prefer_score = [0.0 for n in range(10)]
        temp1 = current['gender'][index].split() + current['age'][index].split()
        temp2 = current['score'][index].split()
        for i in range(len(prefer_score)):
            if i < 5:
                prefer_score[i] += (float(temp1[0])*float(temp2[0])*float(temp2[i+2])*float(temp1[i+2]))/10000
            else:
                prefer_score[i] += (float(temp1[1])*float(temp2[1])*float(temp2[i-3])*float(temp1[i-3]))/10000
 
        enjoy_score = [0.0 for n in range(5)]
        temp = current['enjoy'][index].replace("%", " ").split()
        enjoy_score[0] += float(temp[0])
        enjoy_score[1] += float(temp[1])
        enjoy_score[2] += float(temp[2])
        enjoy_score[3] += float(temp[3])
        enjoy_score[4] += float(temp[4])
        
                           
        doc_write.document('rank' + str(rank)).set({
        'name' : current['name'][index],
        'genre' : current['genre'][index],
        'gender' : current['gender'][index],
        'age' : current['age'][index],
        'img' : current['img'][index],
        'point' : current['point'][index],
        'content' : current['content'][index],
        'level' : current['level'][index],
        'director' : current['director'][index],
        'people' : current['people'][index],
        'date' : current['date'][index],
        'enjoy' : current['enjoy'][index],
        'score' : current['score'][index],
        'time' : current['time'][index],
        'nation' : current['nation'][index],
        'timetable' : current['timetable'][index],
        'rate' : current['rate'][index],
        'recommend_score' : recommend_score,
        'prefer_score' : prefer_score,
        'enjoy_score' : enjoy_score,
        'rank' : rank
        })
    print('Update Success')
    
def user_vector_update(User, genre_standard, prefer_standard, enjoy_standard):
    doc_write = db.collection(User)
    doc_write.document('vector').set({
    'genre_score' : genre_standard,
    'prefer_score' : prefer_standard,
    'enjoy_score' : enjoy_standard,
    'rank' : -1
    })
    print('Update Success')
 
 
def update_success(User):
    doc_success = db.collection('Logs').document(User)
    Time = doc_success.get().to_dict()
    Time = list(Time.keys())[0]
    
    doc_success.set({
        Time : True
    })
    print('Update Success')
 
def update_recommend(data, context):
 
    path_parts = context.resource.split('/documents/')[1].split('/')
    collection_path = path_parts[0]
    document_path = ''.join(path_parts[1:])
    
    
    person = document_path
    info_ref = db.collection(collection_path)
    info = info_ref.document(person).get().to_dict()
 
 
    genre_standard = standard_genre_vecotor(info['genre'], movie_genre)
    genre_vectors = genre_similarity(info['name'],genre_standard, info['genre'])
    current_genre_vectors = genre_similarity(current['name'],genre_standard, current['genre'])
    
 
    prefer_standard = standard_prefer_vector(info['gender'], info['age'], info['score'])
    prefer_vectors = prefer_similrality(prefer_standard, info['gender'], info['age'], info['score'])
    current_prefer_vectors = prefer_similrality(prefer_standard, current['gender'], current['age'], current['score'])
 
 
    enjoy_standard = standard_enjoy_vector(info['enjoy'])
    enjoy_vectors = enjoy_similrality(enjoy_standard, info['enjoy'])
    current_enjoy_vectors = enjoy_similrality(enjoy_standard, current['enjoy'])
 
 
    user_movie_vectors = movie_vectors(info['name'], genre_vectors, prefer_vectors, enjoy_vectors, info['point'])
    current_user_movie_vectors = movie_vectors(current['name'], current_genre_vectors, current_prefer_vectors, current_enjoy_vectors, current['point'])
 
 
    result_distances, result_names = distance_array(current_user_movie_vectors)
    result_datas = np.array(result_distances).transpose()
    rocommended_moveis, indexes, distances =  min_array(result_names,result_distances)
 
 
    result_update(person, rocommended_moveis, result_distances)
    user_vector_update(person, genre_standard, prefer_standard, enjoy_standard)
    update_success(person)
