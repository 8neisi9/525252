import tkinter as tk
from tkinter import ttk, messagebox
import pyodbc
from decimal import Decimal

CONN = (r"DRIVER={ODBC Driver 17 for SQL Server};SERVER=DESKTOP-8K2J1HC\SQLEXPRESS;"
        r"DATABASE=ProductionDB;Trusted_Connection=yes;")
class App:
    def __init__(self, root):
        self.root = root
        root.title("Анализ заказов")
        root.geometry("800x600")
        try:
            self.conn = pyodbc.connect(CONN)
        except Exception as e:
            messagebox.showerror("Ошибка", str(e)); root.destroy(); return
        self.ui()
        self.load_clients()
        self.load()
    def ui(self):
        top = tk.Frame(self.root, pady=10); top.pack(fill=tk.X, padx=10)

        tk.Label(top, text="Сортировать:").grid(row=0, column=0)
        self.sf = ttk.Combobox(top, values=["date", "client", "total"],
                               state="readonly", width=10)
        self.sf.current(0); self.sf.grid(row=0, column=1, padx=5)
        self.so = tk.StringVar(value="ASC")
        tk.Radiobutton(top, text="↑", variable=self.so, value="ASC",
                       command=self.load).grid(row=0, column=2)
        tk.Radiobutton(top, text="↓", variable=self.so, value="DESC",
                       command=self.load).grid(row=0, column=3)
        tk.Label(top, text="Клиент:").grid(row=1, column=0, pady=5)
        self.cc = ttk.Combobox(top, state="readonly", width=28)
        self.cc.grid(row=1, column=1, columnspan=2)
        tk.Button(top, text="Фильтр", command=self.filter).grid(row=1, column=3, padx=5)
        tk.Button(top, text="Все", command=self.load).grid(row=1, column=4)
        tk.Label(top, text="Поиск:").grid(row=2, column=0, pady=5)
        self.se = tk.Entry(top, width=30); self.se.grid(row=2, column=1, columnspan=2, sticky="w")
        tk.Button(top, text="Найти", command=self.search).grid(row=2, column=3, padx=5)
        tk.Button(top, text="Сброс", command=self.clear).grid(row=2, column=4)
        cols = ("Дата", "Клиент", "Телефон", "Сумма")
        self.tv = ttk.Treeview(self.root, columns=cols, show="headings")
        for c in cols:
            self.tv.heading(c, text=c); self.tv.column(c, width=180, anchor="center")
        self.tv.pack(fill=tk.BOTH, expand=True, padx=10, pady=5)
        self.tv.tag_configure("f", background="yellow")
        bot = tk.Frame(self.root); bot.pack(fill=tk.X, padx=10, pady=5)
        self.lc = tk.Label(bot, text="Заказов: 0", font=("Arial", 11, "bold"))
        self.lc.pack(side=tk.LEFT, padx=20)
        self.ls = tk.Label(bot, text="Сумма: 0.00", font=("Arial", 11, "bold"))
        self.ls.pack(side=tk.LEFT, padx=20)
    def load_clients(self):
        try:
            self.clients = self.conn.cursor().execute(
                "SELECT id, name FROM Clients ORDER BY name").fetchall()
            self.cc["values"] = [f"{c.id} — {c.name}" for c in self.clients]
            if self.clients: self.cc.current(0)
        except Exception as e:
            messagebox.showerror("Ошибка", str(e))

    def load(self, cid=None):
        try:
            # ПРОВЕРКА: сколько данных в БД
            cur = self.conn.cursor()
            cur.execute("SELECT COUNT(*) FROM Orders")
            orders_count = cur.fetchone()[0]
            print(f"Заказов в БД: {orders_count}")

            cur.execute("SELECT COUNT(*) FROM OrderItems")
            items_count = cur.fetchone()[0]
            print(f"Позиций в БД: {items_count}")

            m = {"date": "o.date", "client": "c.name", "total": "total"}
            sql = f"""SELECT o.date, c.name client, c.phone,
                      ISNULL(SUM(oi.sum),0) total
                      FROM Orders o JOIN Clients c ON c.id=o.clientId
                      LEFT JOIN OrderItems oi ON oi.orderId=o.id
                      {"WHERE o.clientId=?" if cid else ""}
                      GROUP BY o.id, o.date, c.name, c.phone
                      ORDER BY {m[self.sf.get()]} {self.so.get()}"""

            cur.execute(sql, cid) if cid else cur.execute(sql)
            rows = cur.fetchall()
            print(f"Результат запроса: {len(rows)} строк")

            self.fill(rows)
        except Exception as e:
            messagebox.showerror("Ошибка", str(e))
    def fill(self, rows):
        self.tv.delete(*self.tv.get_children())
        s = Decimal(0)
        for r in rows:
            self.tv.insert("", tk.END, values=(r.date, r.client, r.phone, f"{r.total:.2f}"))
            s += r.total or 0
        self.lc.config(text=f"Заказов: {len(rows)}")
        self.ls.config(text=f"Сумма: {s:.2f}")
    def filter(self):
        try:
            i = self.cc.current()
            if i >= 0: self.load(self.clients[i].id)
        except Exception as e:
            messagebox.showerror("Ошибка", str(e))

    def search(self):
        q = self.se.get().strip().lower()
        self.clear()
        if not q: return
        n = 0
        for it in self.tv.get_children():
            if any(q in str(v).lower() for v in self.tv.item(it, "values")):
                self.tv.item(it, tags=("f",)); n += 1
        if not n: messagebox.showinfo("Поиск", "Не найдено")
    def clear(self):
        for it in self.tv.get_children():
            self.tv.item(it, tags=())
if __name__ == "__main__":
    try:
        r = tk.Tk(); App(r); r.mainloop()
    except Exception as e:
        messagebox.showerror("Ошибка", str(e))
