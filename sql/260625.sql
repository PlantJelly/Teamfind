create table project_member(
    member_no  number(10)   primary key,
    member_id  varchar2(50)  not null,
    member_pwd varchar2(200),
    nickname   varchar2(50)  not null,
    phone      varchar2(20),
    email      varchar2(100),
    sns_type   varchar2(20),
    role       varchar2(20)  default 'USER' not null,
    reg_date   date          default sysdate
);

create table project_board(
    no       number(10)    primary key,
    title    varchar2(200) not null,
    writer   varchar2(50)  not null,
    content  clob          not null,
    view_cnt number(10)    default 0,
    reg_date date          default sysdate
);

create table project_reply(
    no        number(10)    primary key,
    board_no  number(10)    not null,
    parent_no number(10)    default 0,
    depth     number(3)     default 0,
    content   varchar2(1000) not null,
    writer    varchar2(50)  not null,
    reg_date  date          default sysdate
);

create table project_team(
    no             number(10)    primary key,
    writer_no      number(10)    not null,
    writer         varchar2(50)  not null,
    title          varchar2(200) not null,
    description    varchar2(2000),
    requirements   varchar2(1000),
    max_member     number(5)     default 0,
    current_member number(5)     default 0,
    status         varchar2(10)  default 'OPEN',
    apply_deadline date,
    team_deadline  date,
    reg_date       date          default sysdate
);

create table project_team_apply(
    no            number(10)    primary key,
    team_no       number(10)    not null,
    applicant_no  number(10)    not null,
    applicant_id  varchar2(50)  not null,
    apply_content varchar2(1000),
    apply_status  varchar2(10)  default 'PENDING',
    reg_date      date          default sysdate
);

create table project_notification(
    no               number(10)    primary key,
    receiver_no      number(10)    not null,
    message          varchar2(500) not null,
    is_read          varchar2(1)   default 'N',
    related_board_no number(10),
    related_team_no  number(10),
    reg_date         date          default sysdate
);

create sequence seq_project_member_no nocache;

create sequence seq_project_board_no  nocache;

create sequence seq_project_reply_no  nocache;

create sequence seq_project_team_no   nocache;

create sequence seq_project_team_apply_no   nocache;

create sequence seq_project_notification_no nocache;


alter table project_member add constraint uq_project_member_id unique(member_id);

alter table project_reply add constraint fk_project_reply_board_no
foreign key(board_no) references project_board(no) on delete cascade;

alter table project_team add constraint fk_project_team_writer_no
foreign key(writer_no) references project_member(member_no);

alter table project_team_apply add constraint fk_project_team_apply_team_no
foreign key(team_no) references project_team(no) on delete cascade;

alter table project_team_apply add constraint fk_project_team_apply_applicant
foreign key(applicant_no) references project_member(member_no);

alter table project_notification add constraint fk_project_notification_receiver
foreign key(receiver_no) references project_member(member_no);

alter table project_notification add constraint fk_project_notification_team
foreign key(related_team_no) references project_team(no) on delete set null;


insert into project_member(member_no, member_id, member_pwd, nickname, role)
values(seq_project_member_no.nextval, 'admin', 'admin', '관리자', 'ADMIN');


commit;
