/*ANSI SQL

O/ 00. 개인 정보 조회
O/ 01. 성적 조회 
O/ 02. 출결 관리 및 출결 조회
O/ 03. 공지 게시판
O/ 04. 건의 게시판
O/ 05. 1:1 상담
O/ 06. 스터디 그룹
O/ 07. 스터디 룸 대여
08. 취업 특강
O/ 09. 교사 평가
O/ 10. 과정 평가

*/


select * from tabs; 
--------------------------------------------------------------------------------
---------------------------------00. 개인 정보----------------------------------
--1. 로그인 성공시 교육생의 개인 정보(이름,주민번호, 전화번호, 소득, 재산)와 수강 과정명, 기간, 강의실, 수강상태가 출력된다.
SELECT 
    st.enroll_status as "수강 상태",
    si.name as "이름",
    si.ssn as "주민번호",
    si.tel as "전화번호",
    si.income "소득",
    si. wealth "재산",
    c.name "과정명",
    op.start_date "과정 시작 날짜",
    op.end_date "과정 종료 날짜",
    cr.name "강의실"
FROM tblStudent st
    INNER JOIN tblStudentInfo si
        ON st.studentinfo_seq = si.seq
            INNER JOIN tblOpenClass op
                ON st.openclass_seq = op.seq
                    INNER JOIN tblClassroom cr
                        ON op.classroom_seq = cr.seq
                            INNER JOIN tblClass c
                                ON op.class_seq = c.seq;
        
--------------------------------------------------------------------------------
---------------------------------01. 성적 조회----------------------------------
--1. 성적 정보(과목 번호, 과목명, 과목 기간, 교재명, 교사명, 과목별 배점 정보, 과목별 성적)는 과목별 목록 형태로 출력된다.
--(과정 성적 굳이 없어도 되는 거.. 빼면어떤지)
SELECT
    si.name as "이름",
    s.name as "과목명",
    os.start_date "과목 시작 날짜",
    os.end_date "과목 종료 날짜",
    b.name as "교재명",
    t.name as "교사명",
    sgi.written_grade "필기 배점",
    sgi.coding_grade "실기 배점",
    sgi.attendance_grade "출결 배점",
    s_sg.written_score as "필기 점수",
    s_sg.coding_score as "실기 점수",
    s_sg.attendance_score as "출결 점수"    
FROM tblStudent st
 INNER JOIN tblStudentInfo si
        ON st.studentinfo_seq = si.seq
            INNER JOIN tblStudent_SubjectGrade s_sg
                ON st.seq = s_sg.student_seq
                    INNER JOIN tblOpenSubject os
                        ON s_sg.opensubject_seq = os.seq
                            INNER JOIN tblSubject s
                                ON os.subject_seq = s.seq
                                    INNER JOIN tblTeacher_Subject t_s
                                        ON t_s.subject_seq = s.seq
                                            INNER JOIN tblTeacher t
                                                ON t.seq = t_s.teacher_seq
                                                    INNER JOIN tblBook b
                                                        ON b.seq = t_s.teacher_seq
                                                            INNER JOIN tblSubjectGradeInfo sgi
                                                                ON os.seq = sgi.opensubject_seq;    


--------------------------------------------------------------------------------
-------------------------02. 출결 관리 및 출결 조회-----------------------------
--1. 전체 기간 조회
SELECT
    ad.checkin as "입실 시간",
    ad.checkout as "퇴실 시간",
    ad.state as "근태 상황"
FROM tblAttendance ad
    INNER JOIN tblStudent st
        on ad.student_seq = st.seq
    WHERE ad.student_seq = 2; --교육생 번호 입력


--2. 월별 조회
SELECT
    ad.checkin as "입실 시간",
    ad.checkout as "퇴실 시간",
    ad.state as "근태 상황"
FROM tblAttendance ad
    INNER JOIN tblStudent st
        on ad.student_seq = st.seq
    WHERE to_char(ad.checkin) like '%/01/%' and ad.student_seq = 2; -- 22/01/% 원하는 년,월 입력, 교육생 번호 입력



--3. 일별 조회
SELECT
    ad.checkin as "입실 시간",
    ad.checkout as "퇴실 시간",
    ad.state as "근태 상황"
FROM tblAttendance ad
    INNER JOIN tblStudent st
        on ad.student_seq = st.seq
    WHERE to_char(ad.checkin) like '22/01/04' and ad.student_seq = 2; -- %/01/% 원하는 년,월,일 입력, 교육생 번호 입력
    

--------------------------------------------------------------------------------
--------------------------------03. 공지 게시판---------------------------------연결 아예 안되어있는??//공지, 학습, 취업
SELECT
    title as "제목",
    content as "내용",
    creation_date "작성일"
FROM tblNewsBox;
    --제목 또는 내용으로 검색 하고 싶을 때 사용 : WHERE to_char(title) like '%휴무%' ;  

SELECT
    tbl.type "분류명",
    tb.title as "제목",
    tb.content as "내용",
    tb.creation_date "작성일"
FROM tblTipBox tb
    INNER JOIN tblTipBoxList tbl
        ON tb.seq = tbl.tipbox_seq;
    --제목 또는 내용으로 검색 하고 싶을 때 사용 : WHERE to_char(title) like '%휴무%' ; 

SELECT
    jbl.type "분류명",
    jb.title as "제목",
    jb.content as "내용",
    jb.creation_date "작성일"
FROM tblJobBox jb
    INNER JOIN tblJobBoxList jbl
        ON jb.seq = jbl.jobbox_seq;
    --제목 또는 내용으로 검색 하고 싶을 때 사용 : WHERE to_char(title) like '%휴무%' ; 
--------------------------------------------------------------------------------
--------------------------------04. 건의 게시판---------------------------------
--게시판 조회
SELECT
    title as "제목",
    content as "내용",
    creation_date as "작성일"
FROM tblAskBox;
--게시판 작성
INSERT INTO tblAskBox (seq, title, content, creation_date) VALUES (ASKBOX_SEQ.NEXTVAL, '글을 추가할게요', '2024-08-19');


--------------------------------------------------------------------------------
---------------------------------05. 1:1 상담-----------------------------------
--요청
INSERT INTO tblMentoring (seq, student_seq, mentor_seq, mentor_date, mentor_type) VALUES (MENTORING_SEQ.NEXTVAL, 교육생 번호, 3, '2023-08-19', '기타');


--------------------------------------------------------------------------------
-------------------------------06. 스터디 그룹----------------------------------
--신청(그룹 번호, 학생 번호)
INSERT INTO tblStudent_StudyGroup VALUES (student_studygroup_seq.NEXTVAL, 1,  73);
--신청(담당 교사(코칭 유무), 그룹 번호, 결성일, 목적)
INSERT INTO tblStudyGroup VALUES(studygroup_seq.NEXTVAL, NULL, '그룹1'  , '2021-01-04', '공부하려고');


--------------------------------------------------------------------------------
------------------------------07. 스터디 룸 대여-------------------------------- 
--조회
SELECT
    bif.reserve_date as "이용 날짜",
    cr.name as "예약 강의실(대여 X)",
    bif.start_time as "이용 시작",
    bif.end_time as "이용 종료"
FROM tblBookingInfo bif
    INNER JOIN tblStudent_BookingInfo s_bif
        ON bif.seq = s_bif.bookinginfo_seq
            INNER JOIN tblStudent st
                ON st.seq = s_bif.student_seq 
                    INNER JOIN tblClassroom cr
                        ON cr.seq = bif.classroom_seq
    WHERE bif.reserve_date = DATE '2022-01-15'; --왜 시작, 종료 시각이 다음날인지?//시간은 왜 안뜨징

--신청
INSERT INTO tblBookingInfo VALUES (BOOKINGINFO_SEQ.NEXTVAL, 3, 2024/08/19, 2024/08/26, 7:00:00, 9:00:00); 


--------------------------------------------------------------------------------
------------------------------08. 취업 특강 신청-------------------------------- 
--company에서 회사 분류 가져오기 -> 특강 진행 -> 특강 조회 -> 신청 순으로



--------------------------------------------------------------------------------
------------------------------09. 교사 평가 진행-------------------------------- 
--조회
SELECT
    teacher_seq as "교사 번호",
    student_seq as "학생 번호",
    q1, q2, q3, q4, q5,
    suggestion as "기타 의견"
FROM tblTeacherRating
    WHERE student_seq = 3; --학생 번호

--작성
INSERT INTO tblTeacherRating VALUES(1, 교사 번호,학생 번호 ,1 ,1 ,1 ,5 ,5 , '수업이 흥미롭습니다.');


--------------------------------------------------------------------------------
------------------------------10. 과정 평가 진행--------------------------------
SELECT
    openclass_seq as "과정 번호",
    student_seq as "학생 번호",
    q1, q2, q3, q4, q5,
    suggestion as "기타 의견"
FROM tblClassRating
    WHERE student_seq = 6; --학생 번호

--작성
INSERT INTO tblClassRating VALUES (seqClassRating.NEXTVAL, 과정 번호, 학생 번호, 5, 5, 5, 5, 4, '과정이 마음에 들어요.');
