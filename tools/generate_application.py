from pathlib import Path

from reportlab.lib import colors
from reportlab.lib.pagesizes import A4
from reportlab.lib.styles import ParagraphStyle, getSampleStyleSheet
from reportlab.lib.units import mm
from reportlab.pdfbase import pdfmetrics
from reportlab.pdfbase.ttfonts import TTFont
from reportlab.platypus import Paragraph, SimpleDocTemplate, Spacer, Table, TableStyle

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / "output" / "pdf"
OUT.mkdir(parents=True, exist_ok=True)
PDF_PATH = OUT / "MoonContractKit_项目申报书_提交版.pdf"


def register_font() -> str:
    for font in [
        Path("C:/Windows/Fonts/msyh.ttc"),
        Path("C:/Windows/Fonts/simhei.ttf"),
        Path("C:/Windows/Fonts/simsun.ttc"),
    ]:
        if font.exists():
            pdfmetrics.registerFont(TTFont("CN", str(font)))
            return "CN"
    return "Helvetica"


FONT = register_font()
styles = getSampleStyleSheet()
title = ParagraphStyle(
    "TitleCN",
    parent=styles["Title"],
    fontName=FONT,
    fontSize=18,
    leading=24,
    alignment=1,
    textColor=colors.HexColor("#18324A"),
    spaceAfter=10,
)
heading = ParagraphStyle(
    "HeadingCN",
    parent=styles["Heading2"],
    fontName=FONT,
    fontSize=12,
    leading=16,
    textColor=colors.HexColor("#245B83"),
    spaceBefore=5,
    spaceAfter=3,
)
body = ParagraphStyle(
    "BodyCN",
    parent=styles["BodyText"],
    fontName=FONT,
    fontSize=9.0,
    leading=13.0,
    spaceAfter=3,
)
small = ParagraphStyle("SmallCN", parent=body, fontSize=8.3, leading=11.6)


def p(text: str, style=body) -> Paragraph:
    return Paragraph(text.replace("\n", "<br/>"), style)


def info_table(rows):
    table = Table([[p(k, small), p(v, small)] for k, v in rows], colWidths=[34 * mm, 130 * mm])
    table.setStyle(
        TableStyle(
            [
                ("FONTNAME", (0, 0), (-1, -1), FONT),
                ("GRID", (0, 0), (-1, -1), 0.25, colors.HexColor("#B7C6D1")),
                ("BACKGROUND", (0, 0), (0, -1), colors.HexColor("#EEF5F8")),
                ("VALIGN", (0, 0), (-1, -1), "TOP"),
                ("LEFTPADDING", (0, 0), (-1, -1), 6),
                ("RIGHTPADDING", (0, 0), (-1, -1), 6),
                ("TOPPADDING", (0, 0), (-1, -1), 4),
                ("BOTTOMPADDING", (0, 0), (-1, -1), 4),
            ]
        )
    )
    return table


story = [p("MoonContractKit 项目申报书", title)]
story.append(
    info_table(
        [
            ("项目名称", "MoonContractKit：面向 MoonBit 的数据契约、兼容性检查与发布门禁基础库"),
            ("参赛者", "高彬峰"),
            ("联系方式", "19175269519"),
            ("GitHub 仓库", "https://github.com/Gsf-999/MoonContractKit"),
            ("GitLink 仓库", "https://www.gitlink.org.cn/Gsf-s/MoonContractKit"),
            ("项目方向", "MoonBit 数据治理基础库 / 契约兼容性与 CI 发布门禁"),
            ("是否移植", "否，原创 MoonBit 基础库"),
        ]
    )
)
story.append(Spacer(1, 5))

sections = [
    (
        "一、项目简介",
        "MoonContractKit 面向 MoonBit 生态提供数据契约、兼容性检查、运行时载荷校验和发布门禁能力。项目适合事件流、SDK、API 载荷、分析导出和生产者/消费者系统，帮助开发者在发布前发现必填字段删除、字段类型变更、新增必填字段、PII 标记变化和载荷不符合契约等问题。",
    ),
    (
        "二、核心价值",
        "很多系统只在运行时才发现契约漂移：上游改了字段，下游解析失败；普通字段变成个人信息，却没有复核；新版本增加必填字段，旧生产者无法发送。MoonContractKit 把这些风险前置到 MoonBit 代码和 CI 中，用确定性报告回答“这个契约变更能不能发布”。",
    ),
    (
        "三、已实现功能",
        "1. DataContract、ContractField、FieldType 等数据契约模型。\n2. compare_contracts 比较新旧契约，输出 breaking、risky、additive 分类。\n3. validate_payload 校验观测载荷，识别缺失必填字段、类型不匹配和额外字段。\n4. PII classification 变化进入 risky review。\n5. strict_contract_gate 生成 CI 友好的 allow/warn/block 决策。\n6. JSON 输出、CLI 演示、11 个回归测试、CI、README、相关工作说明和验收文档。",
    ),
    (
        "四、成熟参考与差异",
        "项目参考 Confluent Schema Registry 的兼容性检查、OpenAPI/AsyncAPI 的契约优先思想，以及 Pact 的消费者契约测试理念。不同之处在于，MoonContractKit 不绑定注册中心、消息队列或具体协议，而是提供一个 MoonBit 原生、可嵌入、可测试的契约治理内核。",
    ),
    (
        "五、创新点",
        "项目不是简单 schema diff，而是面向发布决策：同一份报告同时包含变化分类、载荷校验、隐私风险和 gate 决策。它可以服务代码生成、SDK 发布、事件平台、数据导出和 CI 审核，填补 MoonBit 生态中结构化数据契约治理基础库的空白。",
    ),
    (
        "六、后续计划",
        "后续将补充 JSON/OpenAPI/AsyncAPI 适配层、语义版本建议、消费者快照、契约测试夹具、字段弃用窗口、更多隐私分类策略、HTML 报告和与 GitHub/GitLink CI 的发布门禁示例。",
    ),
]

for name, text in sections:
    story.append(p(name, heading))
    story.append(p(text))

doc = SimpleDocTemplate(
    str(PDF_PATH),
    pagesize=A4,
    rightMargin=18 * mm,
    leftMargin=18 * mm,
    topMargin=16 * mm,
    bottomMargin=16 * mm,
)
doc.build(story)
print(PDF_PATH)
