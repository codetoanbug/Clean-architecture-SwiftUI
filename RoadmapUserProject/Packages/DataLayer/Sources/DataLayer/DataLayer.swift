// The Swift Programming Language
// https://docs.swift.org/swift-book

// DataLayer/Sources/DataLayer/DataLayer.swift
@_exported import Supabase
@_exported import Auth
@_exported import PostgREST

// Export types thay vì instances
public typealias SupabaseClient = Supabase.SupabaseClient
public typealias Session = Auth.Session
public typealias AuthClient = Auth.AuthClient
public typealias PostgrestClient = PostgREST.PostgrestClient
public typealias PostgrestResponse = PostgREST.PostgrestResponse

// Export managers as types, not instances
// Các package khác sẽ tự access .shared
