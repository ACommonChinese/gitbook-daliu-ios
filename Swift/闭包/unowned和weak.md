# unowned和weak

在Objective-C中，遵循标准模式，一般在块外声明对该实例的弱引用，然后在块内声明对该实例的强引用，以便在块执行期间获取它。显然，检查引用是否仍然有效是必要的。为了帮助处理保留周期，Swift引入了一个新的构造来简化并更明确地捕获闭包内的外部变量，即捕获列表。使用捕获列表，可以在函数顶部声明将用于指定应在内部创建哪种引用的外部变量