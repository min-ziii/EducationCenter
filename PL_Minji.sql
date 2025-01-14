D-00. 로그인
-1. 로그인 성공시 교육생의 개인 정보(이름,주민번호, 전화번호, 소득, 재산)와 수강 과정명, 기간, 강의실, 수강상태가 출력된다.
CREATE OR REPLACE PROCEDURE student_private_info(pstudent_seq IN NUMBER)
AS
BEGIN
    FOR private_record IN(
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
                                    ON op.class_seq = c.seq
                                          WHERE st.seq = pstudent_seq
                    )LOOP
                        DBMS_OUTPUT.PUT_LINE(‘==========================’);
                        DBMS_OUTPUT.PUT_LINE('이름: ' || private_record."이름");
                        DBMS_OUTPUT.PUT_LINE('주민번호: ' || private_record."주민번호");
                        DBMS_OUTPUT.PUT_LINE('전화번호: ' || private_record."전화번호");
                        DBMS_OUTPUT.PUT_LINE('소득: ' || private_record."소득");
                        DBMS_OUTPUT.PUT_LINE('재산: ' || private_record."재산");
                        DBMS_OUTPUT.PUT_LINE('과정명: ' || private_record."과정명");
                        DBMS_OUTPUT.PUT_LINE('과정시작날짜: ' || private_record."과정 시작 날짜");
                        DBMS_OUTPUT.PUT_LINE('과정종료날짜: ' || private_record."과정 종료 날짜");
                        DBMS_OUTPUT.PUT_LINE('강의실: ' || private_record."강의실");
                        DBMS_OUTPUT.PUT_LINE(‘==========================’);
                        DBMS_OUTPUT.PUT_LINE('');
                    END LOOP;
END student_private_info;
/
– 조회
BEGIN
    student_private_info('100');
END;
/

–2. 자격증 취득 여부
CREATE OR REPLACE PROCEDURE license_info ( pstudent_seq IN NUMBER, pyear IN NUMBER)
IS
BEGIN
    FOR license_record IN (
    SELECT 
    si.name as "이름",
    st.seq as "학생 번호",
    lcl.type_license as "자격증 종류",
    lcl.name_license as "자격증명",
    lc.get_date "취득일"
FROM tblStudent st
        INNER JOIN tblStudentInfo si
            ON st.studentinfo_seq = si.seq
                INNER JOIN tblLicense lc
                    ON si.seq = lc.studentinfo_Seq
                        INNER JOIN tblLicenseList lcl
                            ON lcl.seq = licenselist_seq
                                WHERE pstudent_seq = st.seq
                                AND EXTRACT(YEAR FROM lc.get_date) = pyear
         )LOOP
            DBMS_OUTPUT.PUT_LINE('이름: ' || license_record."이름");
            DBMS_OUTPUT.PUT_LINE('학생 번호: ' || license_record."학생 번호");
            DBMS_OUTPUT.PUT_LINE('자격증 종류: ' || license_record."자격증 종류");
            DBMS_OUTPUT.PUT_LINE('자격증명: ' || license_record."자격증명");
            DBMS_OUTPUT.PUT_LINE('취득일: ' || license_record."취득일");
            DBMS_OUTPUT.PUT_LINE('');
        END LOOP;
END license_info;
/
– 조회
BEGIN
    license_info(526, 2024);
END;
/



D-01. 성적 조회 
-1. 성적 정보(과목 번호, 과목명, 과목 기간, 교재명, 교사명, 과목별 배점 정보, 과목별 성적)는 과목별 목록 형태로 출력된다.
CREATE OR REPLACE PROCEDURE student_score_info(pstudent_seq IN NUMBER)
AS
BEGIN
    FOR score_record IN(
SELECT
    si.name as "이름",
    s.seq as "과목 번호",
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
                                                                ON os.seq = sgi.opensubject_seq
                                                                       WHERE pstudent_seq = st.seq
                    )LOOP
                        DBMS_OUTPUT.PUT_LINE('이름: ' || score_record."이름");
                        DBMS_OUTPUT.PUT_LINE('과목 번호: ' || score_record."과목 번호");
                        DBMS_OUTPUT.PUT_LINE('과목명: ' || score_record."과목명");
                        DBMS_OUTPUT.PUT_LINE('과목 시작 날짜: ' || score_record."과목 시작 날짜");
                        DBMS_OUTPUT.PUT_LINE('과목 종료 날짜: ' || score_record."과목 종료 날짜");
                        DBMS_OUTPUT.PUT_LINE('교재명: ' || score_record."교재명");
                        DBMS_OUTPUT.PUT_LINE('교사명: ' || score_record."교사명");
                        DBMS_OUTPUT.PUT_LINE('필기 배점: ' || score_record."필기 배점");
                        DBMS_OUTPUT.PUT_LINE('실기 배점: ' || score_record."실기 배점");
                        DBMS_OUTPUT.PUT_LINE('출결 배점: ' || score_record."출결 배점");
                        DBMS_OUTPUT.PUT_LINE('필기 배점: ' || score_record."필기 배점");
                        DBMS_OUTPUT.PUT_LINE('실기 배점: ' || score_record."실기 배점");
                        DBMS_OUTPUT.PUT_LINE('출결 배점: ' || score_record."출결 배점");
                        DBMS_OUTPUT.PUT_LINE('');

                    END LOOP;
END student_score_info;
/
– 조회
BEGIN
    student_score_info('100');
END;
/



D-02. 출결 관리 및 출결 조회 
-1. 출결 조회 [과정 전체]
CREATE OR REPLACE PROCEDURE attendance_info_total(pstudent_seq IN NUMBER)
IS
BEGIN
    FOR attendance_record IN(
    SELECT
    st.seq as "학생 번호",
    si.name as "이름",
    ad.attendance_date as "날짜",
    TO_CHAR(ad.checkin,'HH24:MI:SS') as "입실 시간",
    TO_CHAR(ad.checkout, 'HH24:MI:SS') as "퇴실 시간",
    ad.state as "근태 상황"
FROM tblAttendance ad
    INNER JOIN tblStudent st
        on ad.student_seq = st.seq
            INNER JOIN tblStudentInfo si
                ON si.seq = st.studentinfo_seq
    WHERE pstudent_seq = st.seq
    )LOOP
       DBMS_OUTPUT.PUT_LINE('학생 번호: ' || attendance_record."학생 번호");
       DBMS_OUTPUT.PUT_LINE('이름: ' || attendance_record."이름");
       DBMS_OUTPUT.PUT_LINE('날짜: ' || attendance_record."날짜");
       DBMS_OUTPUT.PUT_LINE('입실 시간: ' || attendance_record."입실 시간");
       DBMS_OUTPUT.PUT_LINE('퇴실 시간: ' || attendance_record."퇴실 시간");
       DBMS_OUTPUT.PUT_LINE('근태 상황: ' || attendance_record."근태 상황");
       DBMS_OUTPUT.PUT_LINE('');
    END LOOP;
END attendance_info_total;
/
– 조회 학생 입력
BEGIN
    attendance_info_total(100);
END;
/

-2. 출결 조회 [월]
CREATE OR REPLACE PROCEDURE attendance_info_month(pstudent_seq IN NUMBER, pyear IN NUMBER, pmonth IN NUMBER)
IS
BEGIN
    FOR attendance_record IN(
    SELECT
    st.seq as "학생 번호",
    si.name as "이름",
    ad.attendance_date as "날짜",
    TO_CHAR(ad.checkin,'HH24:MI:SS') as "입실 시간",
    TO_CHAR(ad.checkout, 'HH24:MI:SS') as "퇴실 시간",
    ad.state as "근태 상황"
FROM tblAttendance ad
    INNER JOIN tblStudent st
        on ad.student_seq = st.seq
            INNER JOIN tblStudentInfo si
                ON si.seq = st.studentinfo_seq
    WHERE pstudent_seq = st.seq
    AND EXTRACT(YEAR FROM ad.attendance_date) = pyear
    AND EXTRACT(MONTH FROM ad.attendance_date) = pmonth
    )LOOP
       DBMS_OUTPUT.PUT_LINE('학생 번호: ' || attendance_record."학생 번호");
       DBMS_OUTPUT.PUT_LINE('이름: ' || attendance_record."이름");
       DBMS_OUTPUT.PUT_LINE('날짜: ' || attendance_record."날짜");
       DBMS_OUTPUT.PUT_LINE('입실 시간: ' || attendance_record."입실 시간");
       DBMS_OUTPUT.PUT_LINE('퇴실 시간: ' || attendance_record."퇴실 시간");
       DBMS_OUTPUT.PUT_LINE('근태 상황: ' || attendance_record."근태 상황");
       DBMS_OUTPUT.PUT_LINE('');
    END LOOP;
END attendance_info_month;
/
– 조회 학생 번호, 년도, 월 입력
BEGIN
    attendance_info_month(100, 2022, 3);
END;
/

-3. 출결 조회 [일]
CREATE OR REPLACE PROCEDURE attendance_info_day(pstudent_seq IN NUMBER, pyear IN NUMBER, pmonth IN NUMBER, pday IN NUMBER)
IS
BEGIN
    FOR attendance_record IN(
    SELECT
    st.seq as "학생 번호",
    si.name as "이름",
    ad.attendance_date as "날짜",
    TO_CHAR(ad.checkin,'HH24:MI:SS') as "입실 시간",
    TO_CHAR(ad.checkout, 'HH24:MI:SS') as "퇴실 시간",
    ad.state as "근태 상황"
FROM tblAttendance ad
    INNER JOIN tblStudent st
        on ad.student_seq = st.seq
            INNER JOIN tblStudentInfo si
                ON si.seq = st.studentinfo_seq
    WHERE pstudent_seq = st.seq
    AND EXTRACT(YEAR FROM ad.attendance_date) = pyear
    AND EXTRACT(MONTH FROM ad.attendance_date) = pmonth
    AND EXTRACT(DAY FROM ad.attendance_date) = pday
    )LOOP
       DBMS_OUTPUT.PUT_LINE('학생 번호: ' || attendance_record."학생 번호");
       DBMS_OUTPUT.PUT_LINE('이름: ' || attendance_record."이름");
       DBMS_OUTPUT.PUT_LINE('날짜: ' || attendance_record."날짜");
       DBMS_OUTPUT.PUT_LINE('입실 시간: ' || attendance_record."입실 시간");
       DBMS_OUTPUT.PUT_LINE('퇴실 시간: ' || attendance_record."퇴실 시간");
       DBMS_OUTPUT.PUT_LINE('근태 상황: ' || attendance_record."근태 상황");
       DBMS_OUTPUT.PUT_LINE('');
    END LOOP;
END attendance_info_day;
/
– 조회 학생 번호, 년도, 월, 일 입력
BEGIN
    attendance_info_day(100, 2022, 3, 29);
END;
/



D-03. 공지 게시판 
-1. 공지 사항
CREATE OR REPLACE PROCEDURE news_box
IS
BEGIN
FOR news_record IN (
SELECT
    title as "제목",
    content as "내용",
    creation_date "작성일"
FROM tblNewsBox
    )LOOP
         DBMS_OUTPUT.PUT_LINE('제목: ' || news_record."제목");
         DBMS_OUTPUT.PUT_LINE('내용: ' || news_record."내용");
         DBMS_OUTPUT.PUT_LINE('작성일: ' || news_record."작성일");
         DBMS_OUTPUT.PUT_LINE('');
    END LOOP;
END news_box;
/
– 조회
BEGIN
    news_box;
END;
/


-2. 학습 관련 자료
CREATE OR REPLACE PROCEDURE tip_box
IS
BEGIN
FOR tip_record IN (
SELECT
    tbl.type "분류명",
    tb.title as "제목",
    tb.content as "내용",
    tb.creation_date "작성일"
FROM tblTipBox tb
    INNER JOIN tblTipBoxList tbl
        ON tb.seq = tbl.tipbox_seq
    )LOOP
         DBMS_OUTPUT.PUT_LINE('분류명: ' || tip_record."분류명");
         DBMS_OUTPUT.PUT_LINE('제목: ' || tip_record."제목");
         DBMS_OUTPUT.PUT_LINE('내용: ' || tip_record."내용");
         DBMS_OUTPUT.PUT_LINE('작성일: ' || tip_record."작성일");
         DBMS_OUTPUT.PUT_LINE('');
    END LOOP;
END tip_box;
/
– 조회
BEGIN
    tip_box;
END;
/

-3. 취업 관련 자료
CREATE OR REPLACE PROCEDURE job_box
IS
BEGIN
FOR job_record IN (
SELECT
    jbl.type "분류명",
    jb.title as "제목",
    jb.content as "내용",
    jb.creation_date "작성일"
FROM tblJobBox jb
    INNER JOIN tblJobBoxList jbl
        ON jb.seq = jbl.jobbox_seq
    )LOOP
         DBMS_OUTPUT.PUT_LINE('분류명: ' || job_record."분류명");
         DBMS_OUTPUT.PUT_LINE('제목: ' || job_record."제목");
         DBMS_OUTPUT.PUT_LINE('내용: ' || job_record."내용");
         DBMS_OUTPUT.PUT_LINE('작성일: ' || job_record."작성일");
         DBMS_OUTPUT.PUT_LINE('');
    END LOOP;
END job_box;
/
– 조회
BEGIN
    job_box;
END;
/



D-04. 건의 게시판 
-1. 건의 게시판
CREATE OR REPLACE PROCEDURE ask_box
IS
BEGIN
FOR ask_record IN (
SELECT
    title as "제목",
    content as "내용",
    creation_date as "작성일"
FROM tblAskBox
    )LOOP
        DBMS_OUTPUT.PUT_LINE('제목: ' || ask_record."제목");
        DBMS_OUTPUT.PUT_LINE('내용: ' || ask_record."내용");
        DBMS_OUTPUT.PUT_LINE('작성일: ' || ask_record."작성일");
        DBMS_OUTPUT.PUT_LINE('');
    END LOOP;
END ask_box;
/
– 조회
BEGIN
    ask_box;
END;
/

-2. 게시판 작성
CREATE OR REPLACE PROCEDURE askbox_insert(
    p_title tblAskBox.title%type,
    p_content tblAskBox.content%type,
    p_creation_date tblAskBox.creation_date%type
)
IS
BEGIN
    INSERT INTO tblAskBox (seq, title, content, creation_date) VALUES (ASKBOX_SEQ.NEXTVAL, p_title, p_content, p_creation_date);
            DBMS_OUTPUT.PUT_LINE('게시물 작성이 완료되었습니다.');
END askbox_insert;
/

– 작성 
DECLARE
    v_title tblAskBox.title%type := '제목을 입력하세요';
    v_content tblAskBox.content%type := '내용을 입력하세요';
    v_creation_date tblAskBox.creation_date%type := '2024/08/19';
BEGIN
    askbox_insert(v_title, v_content, v_creation_date);
END;
/  



D-05. 1:1 상담 
-1. 상담 요청
CREATE OR REPLACE PROCEDURE mentoring_insert(
    p_student_seq tblmentoring.student_seq%type,
    p_mentor_seq tblmentoring.mentor_seq%type,
    p_mentor_date tblmentoring.mentor_date%type,
    p_mentor_type tblmentoring.mentor_type%type
)
IS
BEGIN
    INSERT INTO tblMentoring (seq, student_seq, mentor_seq, mentor_date, mentor_type) VALUES (MENTORING_SEQ.NEXTVAL, p_student_seq, p_mentor_seq, p_mentor_date, p_mentor_type);
    
    
                    DBMS_OUTPUT.PUT_LINE('상담 신청이 완료되었습니다.');
END;
/

– 신청서 작성
DECLARE
    v_student_seq tblmentoring.student_seq%type := 100;
    v_mentor_seq tblmentoring.mentor_seq%type := 3;
    v_mentor_date tblmentoring.mentor_date%type := '2024/08/19';
    v_mentor_type tblmentoring.mentor_type%type := '기타';
BEGIN
    mentoring_insert(v_student_seq, v_mentor_seq, v_mentor_date, v_mentor_type);
END;
/



D-06. 스터디 그룹 
-1. 스터디 그룹
CREATE OR REPLACE PROCEDURE studygroup_insert(
    p_teacher_seq tblStudyGroup.teacher_seq%type,
    p_name tblStudyGroup.name%type,
    p_creation_date tblStudyGroup.creation_date%type,
    p_goal tblStudyGroup.goal%type
)
IS
BEGIN
    insert into tblStudyGroup(seq, teacher_seq, name, creation_date, goal) 
              values (studygroup_seq.NEXTVAL, p_teacher_seq, p_name, p_creation_date, p_goal);
                    DBMS_OUTPUT.PUT_LINE('스터디 그룹을 신청하셨습니다. 그룹원을 작성해주세요');
END;
/
– 신청서 작성
DECLARE
    v_teacher_seq tblStudyGroup.teacher_seq%type := 3;
    v_name tblStudyGroup.name%type := '우리반 친구들';
    v_creation_date tblStudyGroup.creation_date%type := '2022/08/20';
    v_goal tblStudyGroup.goal%type := '빠른 취업을 위해서';
BEGIN
    studygroup_insert(v_teacher_seq, v_name, v_creation_date, v_goal);
END;
/
-2. 그룹 구성원
CREATE OR REPLACE PROCEDURE Student_StudyGroup_insert(
    p_studygroup_seq tblStudent_StudyGroup.studygroup_seq%type,
    p_student_seq tblStudent_StudyGroup.student_seq%type
)
IS
BEGIN
    insert into tblStudent_StudyGroup(seq, studygroup_seq, student_seq) 
              values (student_studygroup_seq.NEXTVAL, p_studygroup_seq, p_student_seq);
                    DBMS_OUTPUT.PUT_LINE('신청이 완료되었습니다.');
END;
/
– 구성원 작성
   BEGIN
    --Student_StudyGroup_insert(v_studygroup_seq, v_student_seq);
    Student_StudyGroup_insert(101, 100);
    Student_StudyGroup_insert(101, 103);
    Student_StudyGroup_insert(101, 108);
    Student_StudyGroup_insert(101, 114);
END;
/



D-07. 스터디 룸 대여 
-1. 스터디 룸 대여
CREATE OR REPLACE PROCEDURE booking_info(preserve_date IN DATE)
IS
BEGIN
FOR booking_record IN(
SELECT DISTINCT
    bif.reserve_date as "이용 날짜",
    cr.name as "예약 강의실(대여 X)",
    TO_CHAR(bif.start_time, 'HH24:MI:SS') as "이용 시작",
    TO_CHAR(bif.end_time, 'HH24:MI:SS') as "이용 종료"
FROM tblBookingInfo bif
    INNER JOIN tblStudent_BookingInfo s_bif
        ON bif.seq = s_bif.bookinginfo_seq
            INNER JOIN tblStudent st
                ON st.seq = s_bif.student_seq 
                    INNER JOIN tblClassroom cr
                        ON cr.seq = bif.classroom_seq
                    WHERE bif.reserve_date = preserve_date
        )LOOP
            DBMS_OUTPUT.PUT_LINE('이용 날짜: ' || booking_record."이용 날짜");
            DBMS_OUTPUT.PUT_LINE('예약 강의실(대여 X): ' || booking_record."예약 강의실(대여 X)");
            DBMS_OUTPUT.PUT_LINE('이용 시작: ' || booking_record."이용 시작");
            DBMS_OUTPUT.PUT_LINE('이용 종료: ' || booking_record."이용 종료");
            DBMS_OUTPUT.PUT_LINE('');
        END LOOP;
    END booking_info;
    /
– 대여 상황 조회
BEGIN
    booking_info('2022/01/15');
END;
/

-2. 스터디 룸 대여 신청
CREATE OR REPLACE PROCEDURE booking_insert(
    p_classroom_seq tblBookingInfo.classroom_seq%type,
    p_reserve_date tblBookingInfo.reserve_date%type,
    p_start_time tblBookingInfo.start_time%type,
    p_end_time tblBookingInfo.end_time%type,
    p_confirm_date tblBookingInfo.confirm_date%type DEFAULT SYSDATE
)
IS
BEGIN
    insert into tblBookingInfo(seq, classroom_seq, confirm_date, reserve_date, start_time, end_time) values (BOOKINGINFO_SEQ.NEXTVAL, p_classroom_seq, p_confirm_date, p_reserve_date, p_start_time, p_end_time);

            DBMS_OUTPUT.PUT_LINE('대여 신청중.. 예약번호와 학생 번호를 입력해주세요.');
            
END booking_insert;
/
– 신청서 작성
BEGIN
    booking_insert(
        3, 
        TO_DATE('2024/08/26', 'YYYY/MM/DD'),         
        TO_DATE('2024/08/26 07:00:00', 'YYYY/MM/DD HH24:MI:SS'),
        TO_DATE('2024/08/26 09:00:00', 'YYYY/MM/DD HH24:MI:SS'),
        sysdate
    );
END;
/

-3. 스터디 룸 대여 신청 학생 정보
CREATE OR REPLACE PROCEDURE student_booking_insert(
    p_booking_seq IN NUMBER,
    p_student_seq IN NUMBER
)
IS
BEGIN
    insert into tblStudent_BookingInfo(seq, bookinginfo_seq, student_seq) values (student_bookinginfo_seq.NEXTVAL, p_bookinginfo_seq, p_student_seq);
            DBMS_OUTPUT.PUT_LINE('신청이 완료되었습니다.');
END student_booking_insert;
/
– 예약 신청
BEGIN
    student_booking_info( 144, 1000);
END;
/



D-08. 취업 특강 
-1. 취업 특강 조회
CREATE OR REPLACE PROCEDURE workshop_info(pyear IN NUMBER)
AS
BEGIN
    FOR workshop IN (
SELECT DISTINCT
    ws.name as "취업 특강명",
    ws.workshop_date as "취업 특강 날짜",
    cm.name as "회사명",
    ep.salary as "급여",
    cm.type as "직종 분류",
    ct.name as "회사 위치"
FROM tblWorkshop ws
    INNER JOIN tblWorkshop_Student ws_s
        ON ws.seq = ws_s.workshop_seq
            INNER JOIN tblStudent st
                ON ws_s.student_seq = st.seq
                    INNER JOIN tblWorkshop_Guest ws_g
                        ON ws.seq = ws_g.workshop_seq
                            INNER JOIN tblEmployment ep
                                ON ep.seq = ws_g.employment_seq
                                    INNER JOIN tblCompany cm
                                        ON cm.seq = ep.company_seq
                                            INNER JOIN tblCity ct
                                                ON ct.seq = cm.city_seq
            WHERE EXTRACT(YEAR FROM ws.workshop_date) = pyear
            ) LOOP
                DBMS_OUTPUT.PUT_LINE('취업 특강명: ' || workshop."취업 특강명");
                DBMS_OUTPUT.PUT_LINE('취업 특강 날짜: ' || workshop."취업 특강 날짜");
                DBMS_OUTPUT.PUT_LINE('회사명: ' || workshop."회사명");
                DBMS_OUTPUT.PUT_LINE('급여: ' || workshop."급여");
                DBMS_OUTPUT.PUT_LINE('직종 분류: ' || workshop."직종 분류");
                DBMS_OUTPUT.PUT_LINE('회사 위치: ' || workshop."회사 위치");
                DBMS_OUTPUT.PUT_LINE('');
            END LOOP;
                DBMS_OUTPUT.PUT_LINE('');
                DBMS_OUTPUT.PUT_LINE('');
                DBMS_OUTPUT.PUT_LINE('특강 번호와 학생 번호로 신청이 가능합니다.');

        END workshop_info;
        /
– 조회
BEGIN
    workshop_info(2024);    – 조회 년도 입력
END;
/

-2. 취업 특강 신청
CREATE OR REPLACE PROCEDURE workshop_insert (
    p_workshop_seq tblWorkshop_Student.workshop_seq%type,
    p_student_seq tblWorkshop_Student.student_seq%type
)
IS
BEGIN
    insert into tblWorkshop_Student(seq, workshop_Seq, student_seq) values (seqWorkshop_Student.NEXTVAL, p_workshop_seq, p_student_seq);
              DBMS_OUTPUT.PUT_LINE('특강 신청이 완료되었습니다.');
    END workshop_insert;
/
– 신청서 작성
BEGIN
    workshop_insert(26, 1008);
END;
/
– 신청 취소
DELETE FROM tblWorkshop_Student
WHERE workshop_seq = '26' and student_seq = '1008'; 


D-09. 교사 평가 
-1. 교사 평가 작성
CREATE OR REPLACE PROCEDURE teacherrating_insert (
    p_teacher_seq tblTeacherRating.teacher_seq%type,
    p_student_seq tblTeacherRating.student_seq%type,
    p_q1 tblTeacherRating.q1%type,
    p_q2 tblTeacherRating.q2%type,
    p_q3 tblTeacherRating.q3%type,
    p_q4 tblTeacherRating.q4%type,
    p_q5 tblTeacherRating.q5%type,
    p_suggestion tblTeacherRating.suggestion%type
)
IS
BEGIN
    insert into tblTeacherRating (seq, teacher_seq, student_seq, q1, q2, q3, q4, q5, suggestion) values (4000, p_teacher_seq, p_student_seq, p_q1, p_q2, p_q3, p_q4, p_q5, p_suggestion);
              DBMS_OUTPUT.PUT_LINE('교사 평가를 완료하셨습니다.');
    END teacherrating_insert;
/
– 평가 작성
BEGIN
    teacherrating_insert(4, 1008, 5, 5, 5, 5, 4, null);
END;
/



D-10. 과정 평가 
-1. 과정 평가 작성
CREATE OR REPLACE PROCEDURE classrating_insert (
    p_openclass_seq tblClassRating.openclass_seq%type,
    p_student_seq tblClassRating.student_seq%type,
    p_q1 tblClassRating.q1%type,
    p_q2 tblClassRating.q2%type,
    p_q3 tblClassRating.q3%type,
    p_q4 tblClassRating.q4%type,
    p_q5 tblClassRating.q5%type,
    p_suggestion tblClassRating.suggestion%type
)
IS
BEGIN  
    insert into tblClassRating (seq, openclass_seq, student_seq, q1, q2, q3, q4, q5, suggestion) values (seqClassRating.NEXTVAL, p_openclass_seq, p_student_seq, p_q1, p_q2, p_q3, p_q4, p_q5, p_suggestion);
                  DBMS_OUTPUT.PUT_LINE('과정 평가를 완료하셨습니다.');
    END classrating_insert;
/
– 평가 작성
BEGIN
    classrating_insert(36, 1008, 4,5,5,3,2, '아주 최고의 강의입니다!! 짱추');
END;
/



