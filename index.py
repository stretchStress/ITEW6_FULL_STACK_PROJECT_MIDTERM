"""
CCS Department System — Data Mapping  (3 separate diagrams)
  1. CCS_Student_DataMap.png     — Student Profile (all 10 entities)
  2. CCS_Faculty_DataMap.png     — Faculty Records (all 5 entities)
  3. CCS_RBAC_DataMap.png        — RBAC / Access Control overview
"""
import matplotlib.pyplot as plt
from matplotlib.patches import FancyBboxPatch
import os

OUT_DIR   = os.path.dirname(os.path.abspath(__file__))
FONT      = 'DejaVu Sans Mono'
DPI       = 140

# ── sizes ──────────────────────────────────────────────────────────────────────
FS_TITLE   = 21
FS_LABEL   = 21
FS_HDR     = 15
FS_SUBHDR  = 15
FS_FIELD   = 20
FS_TYPE    = 15
FS_LEG     = 15

FIELD_H    = 0.70
HDR_H      = 0.82
CONF_H     = 0.30
SUBHDR_H   = 0.42
PAD_B      = 0.14
BOX_W      = 9.0
GAP_BOX    = 0.65    # vertical gap between boxes in same column
GAP_COL    = 3.8     # horizontal gap between columns
SPINE_OFF  = 0.55    # spine left-offset from box left edge
MX         = 0.9     # left margin (leaves room for spine)
MY         = 0.5
TITLE_H    = 1.6
LABEL_H    = 0.80
LEG_H      = 4.4

# ── palette ────────────────────────────────────────────────────────────────────
C = dict(
    bg        = '#0C1B2A',
    panel     = '#101E30',
    hdr_s     = '#0A5577',
    hdr_f     = '#4A2480',
    hdr_r     = '#6E1515',
    acc_s     = '#38BDF8',
    acc_f     = '#C084FC',
    acc_r     = '#F87171',
    row_a     = '#142336',
    row_b     = '#0F1D2D',
    txt       = '#EFF6FF',
    dim       = '#94A3B8',
    typ       = '#56708A',
    dA        = '#F87171',
    dS        = '#4ADE80',
    dB        = '#38BDF8',
    div       = '#1C3448',
    titlebg   = '#070F1A',
)

# ══════════════════════════════════════════════════════════════════════════════
#  FIELD DATA
# ══════════════════════════════════════════════════════════════════════════════

student_basic = [
    ('StudentID',       'VARCHAR(12)',    'B'), ('LastName',        'VARCHAR(50)',    'B'),
    ('FirstName',       'VARCHAR(50)',    'B'), ('MiddleName',      'VARCHAR(50)',    'B'),
    ('DateOfBirth',     'DATE',           'B'), ('Age',             'INT (computed)', 'B'),
    ('Sex',             'ENUM',           'B'), ('CivilStatus',     'ENUM',           'B'),
    ('Nationality',     'VARCHAR(40)',    'B'), ('ContactNumber',   'VARCHAR(15)',
                                                     'B'),
    ('Email',           'VARCHAR(100)',   'B'), ('HomeAddress',     'TEXT',           'B'),
    ('YearLevel',       'ENUM',           'B'), ('Program',         'VARCHAR(60)',    'B'),
    ('Section',         'VARCHAR(10)',    'B'), ('StudentStatus',   'ENUM',           'B'),
    ('ScholarshipType', 'VARCHAR(60)',    'A'), ('DateEnrolled',    'DATE',           'B'),
    ('CreatedBy',       'VARCHAR(50)',    'A'), ('DateCreated',     'DATETIME',       'A'),
]
student_failed = [
    ('AcadRecordID',    'INT PK',         'A'), ('StudentID',       'FK',             'A'),
    ('CourseCode',      'VARCHAR(15)',    'A'), ('CourseName',      'VARCHAR(100)',   'A'),
    ('FinalGrade',      'DECIMAL(4,2)',   'A'), ('AcademicYear',    'VARCHAR(9)',     'A'),
    ('Semester',        'ENUM',           'A'), ('RetakeStatus',    'ENUM',           'A'),
    ('InstructorRef',   'VARCHAR(100)',   'A'), ('Remarks',         'TEXT',           'A'),
]
student_status = [
    ('StatusID',        'INT PK',         'A'), ('StudentID',       'FK',             'B'),
    ('AcademicYear',    'VARCHAR(9)',     'B'), ('Semester',        'ENUM',           'B'),
    ('IsRegular',       'BOOLEAN',        'B'), ('TotalUnits',      'INT',            'B'),
    ('IrregReason',     'TEXT',           'A'), ('AssessedBy',      'VARCHAR(50)',    'A'),
]
student_loa = [
    ('LOAID',           'INT PK',         'A'), ('StudentID',       'FK',             'A'),
    ('LOAType',         'ENUM',           'A'), ('DateFiled',       'DATE',           'A'),
    ('EffectiveDate',   'DATE',           'A'), ('ReturnDate',      'DATE',           'A'),
    ('ActualReturn',    'DATE',           'A'), ('ApprovedBy',      'VARCHAR(100)',   'A'),
    ('Status',          'ENUM',           'A'), ('SupportingDoc',   'VARCHAR(255)',   'A'),
]
student_events = [
    ('ActivityID',      'INT PK',         'A'), ('StudentID',       'FK',             'S'),
    ('EventName',       'VARCHAR(150)',   'S'), ('EventType',       'ENUM',           'S'),
    ('Role',            'ENUM',           'S'), ('EventDate',       'DATE',           'S'),
    ('Venue',           'VARCHAR(150)',   'S'), ('Award',           'VARCHAR(200)',   'S'),
    ('ProofFile',       'VARCHAR(255)',   'A'),
]
student_sports = [
    ('SportID',         'INT PK',         'A'), ('StudentID',       'FK',             'S'),
    ('SportName',       'VARCHAR(80)',    'S'), ('TeamName',        'VARCHAR(100)',   'S'),
    ('Position',        'VARCHAR(50)',    'S'), ('Level',           'ENUM',           'S'),
    ('AcademicYear',    'VARCHAR(9)',     'S'), ('Achievement',     'VARCHAR(200)',   'S'),
    ('ActiveStatus',    'BOOLEAN',        'S'),
]
student_hobby = [
    ('HobbyID',         'INT PK',         'A'), ('StudentID',       'FK',             'B'),
    ('HobbyName',       'VARCHAR(100)',   'B'), ('Category',        'ENUM',           'B'),
    ('SkillLevel',      'ENUM',           'B'),
]
student_org = [
    ('OrgID',           'INT PK',         'A'), ('StudentID',       'FK',             'S'),
    ('OrgName',         'VARCHAR(150)',   'S'), ('OrgType',         'ENUM',           'S'),
    ('PositionHeld',    'VARCHAR(80)',    'S'), ('YearTerm',        'VARCHAR(9)',     'S'),
    ('SchoolBased',     'BOOLEAN',        'S'), ('Accomplishments', 'TEXT',           'S'),
    ('Adviser',         'VARCHAR(100)',   'A'),
]
student_cert = [
    ('CertID',          'INT PK',         'A'), ('StudentID',       'FK',             'S'),
    ('CertName',        'VARCHAR(200)',   'S'), ('IssuingBody',     'VARCHAR(150)',   'S'),
    ('CertType',        'ENUM',           'S'), ('DateCompleted',   'DATE',           'S'),
    ('ExpiryDate',      'DATE',           'S'), ('DurationHrs',     'INT',            'S'),
    ('CertNumber',      'VARCHAR(50)',    'S'), ('CertFile',        'VARCHAR(255)',   'A'),
]
student_medical = [
    ('MedicalID',       'INT PK',         'A'), ('StudentID',       'FK',             'A'),
    ('ExamDate',        'DATE',           'A'), ('Physician',       'VARCHAR(100)',   'A'),
    ('BloodType',       'ENUM',           'A'), ('Height_cm',       'DECIMAL(5,2)',   'A'),
    ('Weight_kg',       'DECIMAL(5,2)',   'A'), ('BMI',             'DECIMAL(4,2)',   'A'),
    ('BloodPressure',   'VARCHAR(10)',    'A'), ('Conditions',      'TEXT',           'A'),
    ('Medications',     'TEXT',           'A'), ('FitForSchool',    'ENUM',           'A'),
    ('ClearanceFile',   'VARCHAR(255)',   'A'), ('Confidential',    'BOOLEAN',        'A'),
]
faculty_profile = [
    ('FacultyID',       'VARCHAR(10)',    'B'), ('LastName',        'VARCHAR(50)',    'B'),
    ('FirstName',       'VARCHAR(50)',    'B'), ('MiddleName',      'VARCHAR(50)',    'B'),
    ('DateOfBirth',     'DATE',           'A'), ('Sex',             'ENUM',           'B'),
    ('ContactNumber',   'VARCHAR(15)',    'B'), ('InstEmail',       'VARCHAR(100)',   'B'),
    ('EmploymentType',  'ENUM',           'B'), ('FullTimeStatus',  'BOOLEAN',        'B'),
    ('Department',      'VARCHAR(60)',    'B'), ('DateHired',       'DATE',           'A'),
    ('EmployeeNo',      'VARCHAR(15)',    'A'), ('SalaryGrade',     'VARCHAR(10)',    'A'),
    ('TIN',             'VARCHAR(15)',    'A'), ('CreatedBy',       'VARCHAR(50)',    'A'),
]
faculty_education = [
    ('EduID',           'INT PK',         'A'), ('FacultyID',       'FK',             'S'),
    ('DegreeLevel',     'ENUM',           'S'), ('DegreeTitle',     'VARCHAR(150)',   'S'),
    ('Specialization',  'VARCHAR(150)',   'S'), ('Institution',     'VARCHAR(150)',   'S'),
    ('Country',         'VARCHAR(60)',    'S'), ('YearStarted',     'YEAR',           'S'),
    ('YearGraduated',   'YEAR',           'S'), ('DurationYears',   'INT (computed)', 'S'),
    ('ThesisTitle',     'TEXT',           'S'), ('Honors',          'VARCHAR(100)',   'S'),
    ('DiplomaFile',     'VARCHAR(255)',   'A'), ('Verified',        'BOOLEAN',        'A'),
]
faculty_position = [
    ('PositionID',      'INT PK',         'A'), ('FacultyID',       'FK',             'S'),
    ('PositionTitle',   'ENUM',           'S'), ('AcademicRank',    'ENUM',           'S'),
    ('DesigLevel',      'ENUM',           'S'), ('EffectivityDate', 'DATE',           'A'),
    ('EndDate',         'DATE',           'A'), ('AppointType',     'ENUM',           'A'),
    ('AppointOrderNo',  'VARCHAR(50)',    'A'), ('AppointFile',     'VARCHAR(255)',   'A'),
    ('CurrentlyActive', 'BOOLEAN',        'S'),
]
faculty_teaching = [
    ('TeachingID',      'INT PK',         'A'), ('FacultyID',       'FK',             'S'),
    ('AcademicYear',    'VARCHAR(9)',     'S'), ('Semester',        'ENUM',           'S'),
    ('CourseCode',      'VARCHAR(15)',    'S'), ('CourseName',      'VARCHAR(150)',   'S'),
    ('Units',           'INT',            'S'), ('Section',         'VARCHAR(10)',    'S'),
    ('ScheduleDays',    'VARCHAR(30)',    'S'), ('ScheduleTime',    'VARCHAR(30)',    'S'),
    ('Room',            'VARCHAR(80)',    'S'), ('ClassSize',       'INT',            'A'),
]
faculty_cert = [
    ('CertID',          'INT PK',         'A'), ('FacultyID',       'FK',             'S'),
    ('CertName',        'VARCHAR(200)',   'S'), ('CertType',        'ENUM',           'S'),
    ('IssuingBody',     'VARCHAR(150)',   'S'), ('DateCompleted',   'DATE',           'S'),
    ('DurationHrs',     'INT',            'S'), ('Level',           'ENUM',           'S'),
    ('ExpiryDate',      'DATE',           'S'), ('CertFile',        'VARCHAR(255)',   'A'),
    ('FundedBy',        'ENUM',           'A'), ('Verified',        'BOOLEAN',        'A'),
]
rbac_fields = [
    ('AccessID',        'INT PK',         'A'), ('EntityType',      'ENUM',           'A'),
    ('EntityID',        'VARCHAR(12)',    'A'), ('ModuleName',      'VARCHAR(80)',    'A'),
    ('FieldName',       'VARCHAR(80)',    'A'), ('AdminAccess',     'ENUM',           'A'),
    ('StudentAccess',   'ENUM',           'A'), ('FacultyAccess',   'ENUM',           'A'),
    ('SensitivityLvl',  'ENUM',           'A'), ('PrivacyFlag',     'BOOLEAN',        'A'),
    ('LastReviewed',    'DATE',           'A'),
]

# ══════════════════════════════════════════════════════════════════════════════
#  DRAWING UTILITIES
# ══════════════════════════════════════════════════════════════════════════════
def box_height(fields, conf=False):
    return HDR_H + (CONF_H if conf else 0) + SUBHDR_H + len(fields)*FIELD_H + PAD_B

def make_canvas(n_cols, col_heights, title_str):
    """Return fig, ax sized perfectly for this diagram."""
    content_h = max(col_heights)
    fw = MX + SPINE_OFF + n_cols*BOX_W + (n_cols-1)*GAP_COL + MX
    fh = MY + LEG_H + 0.35 + content_h + LABEL_H + TITLE_H + MY
    fig, ax = plt.subplots(figsize=(fw, fh))
    ax.set_xlim(0, fw); ax.set_ylim(0, fh)
    ax.axis('off')
    fig.patch.set_facecolor(C['bg']); ax.set_facecolor(C['bg'])
    base_y = MY + LEG_H + 0.35
    return fig, ax, fw, fh, base_y, content_h

def draw_title(ax, fw, fh, base_y, content_h, title_str, subtitle_str):
    ty = base_y + content_h + LABEL_H + 0.15
    ax.add_patch(FancyBboxPatch((MX, ty), fw-2*MX, 1.30,
        boxstyle="round,pad=0.08", facecolor=C['titlebg'],
        edgecolor=C['acc_s'], linewidth=2.0, zorder=6))
    ax.text(fw/2, ty+0.88, title_str, color='white',
            fontsize=FS_TITLE, fontweight='bold',
            ha='center', va='center', fontfamily=FONT, zorder=7)
    ax.text(fw/2, ty+0.36, subtitle_str, color=C['dim'],
            fontsize=FS_TITLE-6, ha='center', va='center', fontfamily=FONT, zorder=7)

def draw_col_label(ax, cx, base_y, content_h, label, color):
    ly = base_y + content_h + 0.12
    ax.add_patch(FancyBboxPatch((cx+0.15, ly+0.10), BOX_W-0.30, 0.56,
        boxstyle="round,pad=0.07", facecolor=C['titlebg'],
        edgecolor=color, linewidth=2.0, zorder=6))
    ax.text(cx+BOX_W/2, ly+0.38, label, color=color,
            fontsize=FS_LABEL, fontweight='bold',
            ha='center', va='center', fontfamily=FONT, zorder=7)

def draw_entity(ax, x, y, title, fields, hdr_col, accent, conf=False):
    h = box_height(fields, conf)
    # shadow
    ax.add_patch(FancyBboxPatch((x+0.09,y-0.09), BOX_W, h,
        boxstyle="round,pad=0.07", facecolor='black',
        edgecolor='none', alpha=0.50, zorder=1))
    # body
    ax.add_patch(FancyBboxPatch((x,y), BOX_W, h,
        boxstyle="round,pad=0.07", facecolor=C['panel'],
        edgecolor=accent, linewidth=2.5 if conf else 1.8, zorder=2))
    # header
    ax.add_patch(FancyBboxPatch((x, y+h-HDR_H), BOX_W, HDR_H,
        boxstyle="round,pad=0.06", facecolor=hdr_col,
        edgecolor='none', zorder=3))
    ax.text(x+0.28, y+h-HDR_H/2, title, color='white',
            fontsize=FS_HDR, fontweight='bold',
            va='center', ha='left', fontfamily=FONT, zorder=4)
    # confidential stripe
    top_fields = y+h-HDR_H
    if conf:
        ax.add_patch(FancyBboxPatch((x, top_fields-CONF_H), BOX_W, CONF_H,
            boxstyle="square,pad=0", facecolor='#3A0808', edgecolor='none', zorder=3))
        ax.text(x+BOX_W/2, top_fields-CONF_H/2,
                'ADMIN ACCESS ONLY  —  CONFIDENTIAL',
                color=C['acc_r'], fontsize=FS_SUBHDR+0.5, fontweight='bold',
                ha='center', va='center', fontfamily=FONT, zorder=4)
        top_fields -= CONF_H
    # sub-header
    ax.plot([x+0.14, x+BOX_W-0.14], [top_fields-0.03]*2,
            color=accent, lw=0.8, alpha=0.45, zorder=3)
    sub_mid = top_fields - SUBHDR_H/2
    ax.text(x+0.55, sub_mid, 'Field Name', color=C['dim'],
            fontsize=FS_SUBHDR, va='center', ha='left', fontfamily=FONT, zorder=4)
    ax.text(x+BOX_W-0.20, sub_mid, 'Data Type', color=C['dim'],
            fontsize=FS_SUBHDR, va='center', ha='right', fontfamily=FONT, zorder=4)
    ax.plot([x+0.14, x+BOX_W-0.14], [top_fields-SUBHDR_H+0.04]*2,
            color=C['div'], lw=0.9, zorder=3)
    # field rows
    field_top = top_fields - SUBHDR_H
    for i, (fname, ftype, acc) in enumerate(fields):
        fy = field_top - (i+0.5)*FIELD_H
        bg = C['row_a'] if i%2==0 else C['row_b']
        ax.add_patch(FancyBboxPatch((x+0.11, fy-FIELD_H*0.43), BOX_W-0.22, FIELD_H*0.86,
            boxstyle="round,pad=0.03", facecolor=bg, edgecolor='none', zorder=3))
        # access dot
        dc = C['dA'] if acc=='A' else (C['dS'] if acc=='S' else C['dB'])
        ax.plot(x+0.30, fy, 'o', color=dc, markersize=7, zorder=5)
        # PK/FK badge
        nx = x+0.50
        badge = None
        if 'PK' in ftype:  badge = ('PK','#F59E0B','#2D1B00')
        elif ftype=='FK':   badge = ('FK','#60A5FA','#001833')
        if badge:
            bt,bfg,bbg = badge
            bw,bh2 = 0.48,0.32
            ax.add_patch(FancyBboxPatch((nx,fy-bh2/2), bw,bh2,
                boxstyle="round,pad=0.03", facecolor=bbg,
                edgecolor=bfg, linewidth=1.1, zorder=5))
            ax.text(nx+bw/2, fy, bt, color=bfg, fontsize=FS_SUBHDR,
                    fontweight='bold', va='center', ha='center', zorder=6)
            nx += bw+0.12
        ax.text(nx, fy, fname, color=C['txt'], fontsize=FS_FIELD,
                va='center', ha='left', fontfamily=FONT, zorder=5)
        clean = ftype.replace(' PK','').replace('INT PK','INT')
        if clean=='FK': clean=''
        ax.text(x+BOX_W-0.22, fy, clean, color=C['typ'], fontsize=FS_TYPE,
                va='center', ha='right', fontfamily=FONT, style='italic', zorder=5)
    return {'x':x,'y':y,'w':BOX_W,'h':h}

def draw_spine(ax, box_list, color):
    """Bold left-side spine from parent to each child."""
    if len(box_list) < 2: return
    parent   = box_list[0]
    children = box_list[1:]
    px  = parent['x'] - SPINE_OFF
    pmy = parent['y'] + parent['h']/2
    boty = min(b['y']+b['h']/2 for b in children)
    # vertical spine
    ax.plot([px,px],[boty,pmy], color=color, lw=5.0, alpha=1.0,
            solid_capstyle='round', zorder=5)
    # horizontal from parent centre to spine
    ax.plot([parent['x'],px],[pmy,pmy], color=color, lw=5.0, alpha=1.0,
            solid_capstyle='round', zorder=5)
    for b in children:
        cy = b['y']+b['h']/2
        ax.plot([px, b['x']], [cy,cy], color=color, lw=3.5, alpha=1.0,
                solid_capstyle='round', zorder=5)
        ax.annotate('', xy=(b['x'],cy), xytext=(b['x']-0.10,cy),
                    arrowprops=dict(arrowstyle='->', color=color,
                                   lw=2.5, mutation_scale=20), zorder=6)

def draw_link(ax, src, dst, color, lw=2.2, style='dashed'):
    """Fully opaque L-shaped connector."""
    x1 = src['x']+src['w'];  y1 = src['y']+src['h']/2
    x2 = dst['x'];            y2 = dst['y']+dst['h']/2
    mx = (x1+x2)/2
    ax.plot([x1,mx,mx,x2],[y1,y1,y2,y2],
            color=color, lw=lw, alpha=1.0, linestyle=style,
            solid_capstyle='round', zorder=4)

def draw_legend(ax, fw, accent_color):
    lx=MX; ly=0.30; lw2=fw-2*MX; lh=LEG_H-0.20
    ax.add_patch(FancyBboxPatch((lx,ly), lw2,lh,
        boxstyle="round,pad=0.10", facecolor=C['titlebg'],
        edgecolor=C['div'], linewidth=1.8, zorder=5))
    ax.text(lx+lw2/2, ly+lh-0.32, 'LEGEND & ACCESS CONTROL NOTES',
            color='white', fontsize=FS_LEG+3, fontweight='bold',
            ha='center', va='center', fontfamily=FONT, zorder=6)
    ax.plot([lx+0.5,lx+lw2-0.5],[ly+lh-0.60]*2, color=C['div'], lw=1.2, zorder=6)

    # dots
    for i,(dc,role,desc) in enumerate([
        (C['dA'],'Admin Only','Sensitive — restricted from students/faculty'),
        (C['dB'],'Admin + Student / Faculty','General data visible to record owner'),
        (C['dS'],'Student / Faculty (Own record)','Can view own data — read-only access'),
    ]):
        rx = lx+0.6 + i*(lw2/3.1)
        ax.plot(rx+0.22, ly+lh-1.10, 'o', color=dc, markersize=13, zorder=6)
        ax.text(rx+0.55, ly+lh-0.97, role, color=dc,
                fontsize=FS_LEG+1, fontweight='bold',
                va='center', ha='left', fontfamily=FONT, zorder=6)
        ax.text(rx+0.55, ly+lh-1.25, desc, color=C['dim'],
                fontsize=FS_LEG-0.5, va='center', ha='left', fontfamily=FONT, zorder=6)

    # lines
    for i,(lc,ls,ld) in enumerate([
        (C['acc_s'],'solid', 'Parent → Child FK  (one-to-many spine)'),
        (C['acc_s'],'dashed','Cross-module FK link'),
        (C['acc_r'],'dotted','RBAC access-control reference'),
        (C['acc_f'],'solid', 'Faculty FK  (one-to-many spine)'),
    ]):
        rx = lx+0.6 + i*(lw2/4.2)
        ax.plot([rx,rx+1.1],[ly+lh-2.25]*2, color=lc, lw=3.5, linestyle=ls, zorder=6)
        ax.text(rx+1.25, ly+lh-2.25, ld, color=C['dim'],
                fontsize=FS_LEG, va='center', ha='left', fontfamily=FONT, zorder=6)

    # badges
    for i,(bfg,bbg,bt,bd) in enumerate([
        ('#F59E0B','#2D1B00','PK','Primary Key — unique row identifier'),
        ('#60A5FA','#001833','FK','Foreign Key — references parent entity'),
    ]):
        rx = lx+0.6 + i*(lw2/2.1)
        bw2,bh3=0.58,0.38
        ax.add_patch(FancyBboxPatch((rx,ly+lh-3.20-bh3/2), bw2,bh3,
            boxstyle="round,pad=0.04", facecolor=bbg,
            edgecolor=bfg, linewidth=1.3, zorder=6))
        ax.text(rx+bw2/2, ly+lh-3.20, bt, color=bfg,
                fontsize=FS_LEG+1, fontweight='bold',
                va='center', ha='center', zorder=7)
        ax.text(rx+bw2+0.18, ly+lh-3.20, bd, color=C['dim'],
                fontsize=FS_LEG+1, va='center', ha='left', fontfamily=FONT, zorder=6)

    ax.text(lx+lw2/2, ly+0.34,
            '(computed) = derived field   |   All timestamps auto-generated'
            '   |   Data privacy governed by RA 10173 (Philippines)',
            color=C['typ'], fontsize=FS_LEG, ha='center', va='center',
            fontfamily=FONT, zorder=6)

def col_x(col_idx):
    return MX + SPINE_OFF + col_idx*(BOX_W+GAP_COL)

def stack_col(ax, cx, data_list, title_list, hdr_col, acc_col, conf_set, base_y, content_h):
    cy = base_y + content_h
    boxes = []
    hdrs = hdr_col if isinstance(hdr_col, list) else [hdr_col]*len(data_list)
    accs = acc_col if isinstance(acc_col, list) else [acc_col]*len(data_list)
    for i,(fl,title) in enumerate(zip(data_list, title_list)):
        h = box_height(fl, title in conf_set)
        cy -= h
        b = draw_entity(ax, cx, cy, title, fl, hdrs[i], accs[i], conf=(title in conf_set))
        boxes.append(b)
        if i < len(data_list)-1: cy -= GAP_BOX
    return boxes

def save(fig, name):
    path = os.path.join(OUT_DIR, name)
    plt.savefig(path, dpi=DPI, bbox_inches='tight',
                facecolor=C['bg'], edgecolor='none')
    plt.close(fig)
    print('Saved:', path)

# ══════════════════════════════════════════════════════════════════════════════
#  DIAGRAM 1 — STUDENT PROFILE
# ══════════════════════════════════════════════════════════════════════════════
# Layout: 2 columns
#   C0 = Basic Info, Failed, Reg/Irreg, LOA
#   C1 = Events, Sports, Hobbies, Org, Cert, Medical
s_c0 = [student_basic, student_failed, student_status, student_loa]
s_t0 = ['Student — Basic Information','Student — Failed Courses',
        'Student — Reg / Irreg Status','Student — Leave of Absence']

s_c1 = [student_events, student_sports, student_hobby,
        student_org, student_cert, student_medical]
s_t1 = ['Student — Events','Student — Sports / Players','Student — Hobbies',
        'Student — Org Background','Student — Training / Cert','Student — Medical Exam']
s_conf1 = {'Student — Medical Exam'}

h0 = sum(box_height(f) for f in s_c0) + GAP_BOX*(len(s_c0)-1)
h1 = sum(box_height(f, t in s_conf1) for f,t in zip(s_c1,s_t1)) + GAP_BOX*(len(s_c1)-1)

fig, ax, fw, fh, base_y, content_h = make_canvas(2, [h0,h1],
    'CCS — Student Profile Data Map')

draw_title(ax, fw, fh, base_y, content_h,
    'CCS DEPARTMENT SYSTEM — STUDENT PROFILE DATA MAPPING',
    'Student Profile (Intense Profiling)  |  10 Entities  |  Role-Based Access Control (RBAC)')
draw_col_label(ax, col_x(0), base_y, content_h, 'STUDENT — CORE PROFILE', C['acc_s'])
draw_col_label(ax, col_x(1), base_y, content_h, 'STUDENT — ACTIVITIES & HEALTH', C['acc_s'])

boxes0 = stack_col(ax, col_x(0), s_c0, s_t0, C['hdr_s'], C['acc_s'], set(), base_y, content_h)
boxes1 = stack_col(ax, col_x(1), s_c1, s_t1,
    [C['hdr_s']]*5+[C['hdr_r']], [C['acc_s']]*5+[C['acc_r']],
    s_conf1, base_y, content_h)

draw_spine(ax, boxes0, C['acc_s'])

# Basic Info → every C1 box
for b in boxes1:
    draw_link(ax, boxes0[0], b, C['acc_s'], lw=2.0, style='dashed')

draw_legend(ax, fw, C['acc_s'])
save(fig, 'CCS_Student_DataMap.png')

# ══════════════════════════════════════════════════════════════════════════════
#  DIAGRAM 2 — FACULTY RECORDS
# ══════════════════════════════════════════════════════════════════════════════
# Layout: 2 columns
#   C0 = Profile (parent), Education, Position
#   C1 = Course Teaching, Training/Cert
f_c0 = [faculty_profile, faculty_education, faculty_position]
f_t0 = ['Faculty — Profile','Faculty — Education Attained','Faculty — Position']

f_c1 = [faculty_teaching, faculty_cert]
f_t1 = ['Faculty — Course Teaching','Faculty — Training / Cert']

fh0 = sum(box_height(f) for f in f_c0) + GAP_BOX*(len(f_c0)-1)
fh1 = sum(box_height(f) for f in f_c1) + GAP_BOX*(len(f_c1)-1)

fig, ax, fw, fh, base_y, content_h = make_canvas(2, [fh0,fh1],
    'CCS — Faculty Data Map')

draw_title(ax, fw, fh, base_y, content_h,
    'CCS DEPARTMENT SYSTEM — FACULTY RECORDS DATA MAPPING',
    'Faculty Profile  |  5 Entities  |  Role-Based Access Control (RBAC)')
draw_col_label(ax, col_x(0), base_y, content_h, 'FACULTY — PROFILE & EDUCATION', C['acc_f'])
draw_col_label(ax, col_x(1), base_y, content_h, 'FACULTY — TEACHING & CERTIFICATIONS', C['acc_f'])

fboxes0 = stack_col(ax, col_x(0), f_c0, f_t0, C['hdr_f'], C['acc_f'], set(), base_y, content_h)
fboxes1 = stack_col(ax, col_x(1), f_c1, f_t1, C['hdr_f'], C['acc_f'], set(), base_y, content_h)

draw_spine(ax, fboxes0, C['acc_f'])
# Profile → C1 boxes
for b in fboxes1:
    draw_link(ax, fboxes0[0], b, C['acc_f'], lw=2.2, style='dashed')
# Spine on C1 too
draw_spine(ax, fboxes1, C['acc_f'])

draw_legend(ax, fw, C['acc_f'])
save(fig, 'CCS_Faculty_DataMap.png')

# ══════════════════════════════════════════════════════════════════════════════
#  DIAGRAM 3 — RBAC OVERVIEW
# ══════════════════════════════════════════════════════════════════════════════
# Layout: 3 columns
#   C0 = Student summary boxes (Basic, Academic, Activities, Health)
#   C1 = RBAC Control Matrix
#   C2 = Faculty summary boxes (Profile, Education, Position, Teaching, Cert)
# Summary boxes show the table name + FK field only (compact view)
def summary_box(title, pk_field, color):
    """Return a minimal 3-field summary entity."""
    return [(pk_field, 'PK', 'A'), ('StudentID/FacultyID','FK','A'), ('...fields...','...','B')]

# Student summaries
rs_c0 = [
    [('StudentID','VARCHAR(12) PK','B'),('...20 fields...','mixed','B')],
    [('AcadRecordID','INT PK','A'),('StudentID','FK','A'),('CourseCode','VARCHAR(15)','A'),('FinalGrade','DECIMAL','A')],
    [('ActivityID','INT PK','A'),('StudentID','FK','A'),('EventName','VARCHAR(150)','S'),('SportName','VARCHAR(80)','S')],
    [('OrgID','INT PK','A'),('StudentID','FK','A'),('CertID','INT PK','A'),('HobbyID','INT PK','A')],
    [('MedicalID','INT PK','A'),('StudentID','FK','A'),('BloodType','ENUM','A'),('Confidential','BOOLEAN','A')],
]
rs_t0 = [
    'Student — Basic Info',
    'Student — Academic Records',
    'Student — Events & Sports',
    'Student — Org, Cert & Hobbies',
    'Student — Medical Exam',
]

# Faculty summaries
rs_c2 = [
    [('FacultyID','VARCHAR(10) PK','B'),('...16 fields...','mixed','B')],
    [('EduID','INT PK','A'),('FacultyID','FK','S'),('DegreeLevel','ENUM','S'),('Verified','BOOLEAN','A')],
    [('PositionID','INT PK','A'),('FacultyID','FK','S'),('PositionTitle','ENUM','S'),('AcademicRank','ENUM','S')],
    [('TeachingID','INT PK','A'),('FacultyID','FK','S'),('CourseCode','VARCHAR(15)','S'),('ClassSize','INT','A')],
    [('CertID','INT PK','A'),('FacultyID','FK','S'),('CertName','VARCHAR(200)','S'),('Verified','BOOLEAN','A')],
]
rs_t2 = [
    'Faculty — Profile',
    'Faculty — Education',
    'Faculty — Position',
    'Faculty — Teaching',
    'Faculty — Certifications',
]

rbac_only = [rbac_fields]
rbac_titles_only = ['RBAC — Access Control Matrix']

rh0 = sum(box_height(f) for f in rs_c0) + GAP_BOX*(len(rs_c0)-1)
rh1 = box_height(rbac_fields, True)
rh2 = sum(box_height(f) for f in rs_c2) + GAP_BOX*(len(rs_c2)-1)

fig, ax, fw, fh, base_y, content_h = make_canvas(3, [rh0,rh1,rh2],
    'CCS — RBAC Overview')

draw_title(ax, fw, fh, base_y, content_h,
    'CCS DEPARTMENT SYSTEM — RBAC ACCESS CONTROL MAP',
    'Role-Based Access Control  |  Student & Faculty Entity Relationships  |  Admin / Student / Faculty Roles')
draw_col_label(ax, col_x(0), base_y, content_h, 'STUDENT ENTITIES', C['acc_s'])
draw_col_label(ax, col_x(1), base_y, content_h, 'RBAC CONTROL NODE', C['acc_r'])
draw_col_label(ax, col_x(2), base_y, content_h, 'FACULTY ENTITIES', C['acc_f'])

rboxes0 = stack_col(ax, col_x(0), rs_c0, rs_t0,
    [C['hdr_s']]*4+[C['hdr_r']], [C['acc_s']]*4+[C['acc_r']],
    {'Student — Medical Exam'}, base_y, content_h)

# RBAC centred
rbac_bh = box_height(rbac_fields, True)
rbac_y  = base_y + (content_h - rbac_bh)/2
box_rbac = draw_entity(ax, col_x(1), rbac_y,
    'RBAC — Access Control Matrix', rbac_fields,
    C['hdr_r'], C['acc_r'], conf=True)

rboxes2 = stack_col(ax, col_x(2), rs_c2, rs_t2, C['hdr_f'], C['acc_f'],
    set(), base_y, content_h)

# Student spine
draw_spine(ax, rboxes0, C['acc_s'])
# Faculty spine
draw_spine(ax, rboxes2, C['acc_f'])

# Student → RBAC
for b in rboxes0:
    draw_link(ax, b, box_rbac, C['acc_r'], lw=2.2, style='dotted')
# RBAC → Faculty
for b in rboxes2:
    draw_link(ax, box_rbac, b, C['acc_f'], lw=2.2, style='dotted')

draw_legend(ax, fw, C['acc_r'])
save(fig, 'CCS_RBAC_DataMap.png')

print('\nAll 3 diagrams generated successfully.')